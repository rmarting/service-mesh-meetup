package com.redhat.cloudnative.catalog.health;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

import com.redhat.cloudnative.catalog.breakfix.model.BreakFix;
import com.redhat.cloudnative.catalog.breakfix.service.BreakFixService;

@ConditionalOnProperty(value="breakFix.healthCheck.enabled", havingValue="true")
@Component
public class BreakFixHealthCheck implements HealthIndicator {

	@Autowired
	private BreakFixService breakFixService;

	@Override
	public Health health() {
		if (BreakFix.Status.BROKEN.equals(breakFixService.getStatus())) {
			return Health.down().withDetail("[BREAK] Application Status", BreakFix.Status.BROKEN.toString()).build();
		}

		if (BreakFix.Status.DELAYED.equals(breakFixService.getStatus())) {
			return Health.down().withDetail("[BREAK] Application Status", BreakFix.Status.DELAYED.toString()).build();
		}
		
		return Health.up().build();
	}

}
