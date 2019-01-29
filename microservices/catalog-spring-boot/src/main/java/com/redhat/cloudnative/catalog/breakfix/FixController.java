package com.redhat.cloudnative.catalog.breakfix;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.redhat.cloudnative.catalog.breakfix.model.BreakFix;
import com.redhat.cloudnative.catalog.breakfix.service.BreakFixService;

@Controller
@RequestMapping(value = "/api/fix")
public class FixController {

	private static final Logger LOGGER = LoggerFactory.getLogger(FixController.class);

	@Autowired
	private BreakFixService breakFixService;

	@RequestMapping(value = "/sleep", method = RequestMethod.GET)
	@ResponseBody
	@GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
	public BreakFix sleep() {
		LOGGER.info("[FIX] Application fixed. Using {} milliseconds as delay for each request", BreakFix.NO_DELAY);

		return this.breakFixService.fixSleeping();
	}

	@RequestMapping(value = "/exception", method = RequestMethod.GET)
	@ResponseBody
	@GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
	public BreakFix exception() {
		LOGGER.info("[FIX] Application fixed. No throwing exceptions for each request");

		return this.breakFixService.fixBreaking();
	}

}