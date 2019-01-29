package com.redhat.cloudnative.inventory.breakfix;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.jboss.logging.Logger;

import com.redhat.cloudnative.inventory.breakfix.model.BreakFix;
import com.redhat.cloudnative.inventory.breakfix.service.BreakFixService;

@Path("/")
@ApplicationScoped
public class BreakFixResource {
	
	private static final Logger LOGGER = Logger.getLogger(BreakFixResource.class);

	@Inject
	private BreakFixService breakFixService;

	@GET
	@Path("/api/break/status")
	@Produces(MediaType.APPLICATION_JSON)
	public Response status() {
		BreakFix.Status breakFixStatus = this.breakFixService.getStatus();
		
		if (BreakFix.Status.NOT_READY.equals(breakFixStatus)) {
			return Response.status(Response.Status.SERVICE_UNAVAILABLE).entity(breakFixStatus).build();
		}
		
		return Response.status(Response.Status.OK).entity(breakFixStatus).build();
	}
	
	@GET
	@Path("/api/break/sleep/{delay}")
	@Produces(MediaType.APPLICATION_JSON)
	public BreakFix breakSleep(@PathParam("delay") String delay) {
		LOGGER.warnv("[BREAK] Application broken. Using {0} milliseconds as delay for each request", delay);
		
		return this.breakFixService.sleeping(delay);
	}

	@GET
	@Path("/api/fix/sleep")
	@Produces(MediaType.APPLICATION_JSON)
	public BreakFix fixSleep() {
		LOGGER.infov("[FIX] Application fixed. Using {0} milliseconds as delay for each request", BreakFix.NO_DELAY);
		
		return this.breakFixService.fixSleeping();
	}

	@GET
	@Path("/api/break/exception/{message}")
	@Produces(MediaType.APPLICATION_JSON)
	public BreakFix breakException(@PathParam("message") String message) {
		LOGGER.warnv("[BREAK] Application broken. Throwing a '{0}' exception message for each request", message);
		
		return this.breakFixService.breaking(message);
	}

	@GET
	@Path("/api/fix/exception")
	@Produces(MediaType.APPLICATION_JSON)
	public BreakFix fixException() {
		LOGGER.infov("[FIX] Application fixed. No throwing exceptions for each request");
		
		return this.breakFixService.fixBreaking();
	}
	
	@GET
	@Path("/api/break/disabled")
	@Produces(MediaType.APPLICATION_JSON)
	public BreakFix disabled() {
		LOGGER.error("[BREAK] Application not ready. You should redeploy a new version.");

		return this.breakFixService.disabling();
	}
	
}
