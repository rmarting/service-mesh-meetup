package com.redhat.cloudnative.gateway;


import io.vertx.circuitbreaker.CircuitBreakerOptions;
import io.vertx.core.http.HttpMethod;
import io.vertx.core.json.Json;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.client.WebClientOptions;
import io.vertx.rxjava.circuitbreaker.CircuitBreaker;
import io.vertx.rxjava.core.AbstractVerticle;
import io.vertx.rxjava.ext.web.Router;
import io.vertx.rxjava.ext.web.RoutingContext;
import io.vertx.rxjava.ext.web.client.WebClient;
import io.vertx.rxjava.ext.web.codec.BodyCodec;
import io.vertx.rxjava.ext.web.handler.CorsHandler;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import rx.Observable;

public class GatewayVerticle extends AbstractVerticle {
    private static final String MSA_VERSION = "msa-version";

    private static final Logger LOG = LoggerFactory.getLogger(GatewayVerticle.class);

    private WebClient catalog;
    private WebClient inventory;
    private CircuitBreaker circuit;

    @Override
    public void start() {
        // Circuit Breaker Definition
        circuit = CircuitBreaker.create("inventory-circuit-breaker", vertx, new CircuitBreakerOptions()
                .setFallbackOnFailure(true).setMaxFailures(10).setResetTimeout(60000).setTimeout(10000));

        Router router = Router.router(vertx);
        router.route().handler(CorsHandler.create("*").allowedMethod(HttpMethod.GET));
        router.get("/health").handler(ctx -> ctx.response().end(new JsonObject().put("status", "UP").toString()));
        router.get("/api/products").handler(this::products);

        // Server Definition to accept request
        vertx.createHttpServer().requestHandler(router::accept).listen(Integer.getInteger("http.port", 8080));

        // Simple Web Clients to invoke other microservices
        catalog = WebClient.create(vertx);
        inventory = WebClient.create(vertx);
    }

    private void products(RoutingContext rc) {
        String msaVersion = rc.request().getHeader(MSA_VERSION);
        // Retrieve catalog
        catalog.get(8080, "catalog", "/api/catalog").as(BodyCodec.jsonArray()).rxSend().map(resp -> {
            if (resp.statusCode() != 200) {
                new RuntimeException("Invalid response from the catalog: " + resp.statusCode());
            }
            return resp.body();
        }).flatMap(products ->
        // For each item from the catalog, invoke the inventory service
        Observable.from(products).cast(JsonObject.class)
                .flatMapSingle(product -> circuit.rxExecuteCommandWithFallback(
                        future -> inventory.get(8080, "inventory", "/api/inventory/" + product.getString("itemId"))
                                    .as(BodyCodec.jsonObject())
                                    .putHeader(MSA_VERSION, msaVersion)
                                    .rxSend()
                                    .map(resp -> {
                                        if (resp.statusCode() != 200) {
                                            LOG.warn("Inventory error for {}: status code {}",
                                                    product.getString("itemId"), resp.statusCode());
                                            return product.copy();
                                        }
                                        return product.copy().put("availability", 
                                            new JsonObject().put("quantity", resp.body().getInteger("quantity")));
                                    })
                                    .subscribe(
                                        future::complete,
                                        future::fail),
                            error -> {
                                LOG.error("Inventory error for {}: {}", product.getString("itemId"), error.getMessage());
                                return product;
                            }
                        ))
                    .toList().toSingle()
            )
            .subscribe(
                list -> rc.response().end(Json.encodePrettily(list)),
                error -> rc.response().end(new JsonObject().put("error", error.getMessage()).toString())
            );
    }
}
