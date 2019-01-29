package com.redhat.cloudnative.catalog.health;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.actuate.endpoint.Endpoint;
import org.springframework.stereotype.Component;

import com.redhat.cloudnative.catalog.breakfix.model.BreakFix;
import com.redhat.cloudnative.catalog.breakfix.model.BreakFix.Status;
import com.redhat.cloudnative.catalog.breakfix.service.BreakFixService;

@Component
public class BreakFixHealthEndpoint implements Endpoint<BreakFix.Status> {

	@Autowired
	private BreakFixService breakFixService;

	@Override
	public String getId() {
		return "breakFixHealth";
	}

	@Override
	public boolean isEnabled() {
		return true;
	}

	@Override
	public boolean isSensitive() {
		return false;
	}

	@Override
	public Status invoke() {
		return breakFixService.getStatus();
	}

}
