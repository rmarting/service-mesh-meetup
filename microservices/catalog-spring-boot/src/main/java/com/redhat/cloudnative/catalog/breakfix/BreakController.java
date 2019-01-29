package com.redhat.cloudnative.catalog.breakfix;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.redhat.cloudnative.catalog.breakfix.model.BreakFix;
import com.redhat.cloudnative.catalog.breakfix.model.BreakFix.Status;
import com.redhat.cloudnative.catalog.breakfix.service.BreakFixService;

@Controller
@RequestMapping(value = "/api/break")
public class BreakController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BreakController.class);

	@Autowired
	private BreakFixService breakFixService;

	@RequestMapping(value = "/status", method = RequestMethod.GET)
	@ResponseBody
	@GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<Status> status() {
		BreakFix.Status breakFixStatus = this.breakFixService.getStatus();
		
		if (BreakFix.Status.NOT_READY.equals(breakFixStatus)) {
			return new ResponseEntity<>(breakFixStatus, HttpStatus.LOCKED);
		}
		
		return new ResponseEntity<>(breakFixStatus, HttpStatus.OK);
	}

	@RequestMapping(value = "/sleep/{delay}", method = RequestMethod.GET)
	@ResponseBody
	@GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
	public BreakFix breakSleep(@PathVariable("delay") String delay) {
		LOGGER.warn("[BREAK] Application broken. Using {} milliseconds as delay for each request", delay);

		return this.breakFixService.sleeping(delay);
	}

	@RequestMapping(value = "/exception/{message}", method = RequestMethod.GET)
	@ResponseBody
	@GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
	public BreakFix breakException(@PathVariable("message") String message) {
		LOGGER.warn("[BREAK] Application broken. Throwing a '{}' exception message for each request", message);

		return this.breakFixService.breaking(message);
	}

	@RequestMapping(value = "/disabled", method = RequestMethod.GET)
	@ResponseBody
	@GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
	public BreakFix breakException() {
		LOGGER.error("[BREAK] Application not ready. You should redeploy a new version.");

		return this.breakFixService.disabling();
	}
	
}