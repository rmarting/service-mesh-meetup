package com.redhat.cloudnative.inventory;

import java.util.Random;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import com.redhat.cloudnative.inventory.breakfix.service.BreakFixService;

@Path("/")
@ApplicationScoped
public class InventoryResource {

	@PersistenceContext(unitName = "InventoryPU")
	private EntityManager em;

	@Inject
	private BreakFixService breakFixService;

	@GET
	@Path("/api/inventory/{itemId}")
	@Produces(MediaType.APPLICATION_JSON)
	public Response getAvailability(@PathParam("itemId") String itemId) {
		Inventory inventory = em.find(Inventory.class, itemId);

		Response.Status httpStatus = Response.Status.OK;

		// Break & Fix
		try {
			this.breakFixService.process();
		} catch (RuntimeException re) {
			inventory = null; // No data
			if ((new Random()).nextInt(10) % 2 == 0) {
				httpStatus = Response.Status.INTERNAL_SERVER_ERROR;
			} else {
				httpStatus = Response.Status.NOT_FOUND;
			}
		}

		if (inventory == null) {
			inventory = new Inventory();
			inventory.setItemId(null);
			inventory.setQuantity(0);
		}

		return Response.status(httpStatus).entity(inventory).build();
	}

}
