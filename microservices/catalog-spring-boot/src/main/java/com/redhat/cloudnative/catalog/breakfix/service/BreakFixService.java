package com.redhat.cloudnative.catalog.breakfix.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.redhat.cloudnative.catalog.breakfix.model.BreakFix;

@Service
public class BreakFixService {

	private static final Logger LOGGER = LoggerFactory.getLogger(BreakFixService.class);

	private BreakFix breakFix = null;

	public BreakFixService() {
		this.breakFix = new BreakFix();
	}

	/**
	 * @param delay Delay in milliseconds
	 * @return Status of the break&fix
	 */
	public BreakFix sleeping(String delay) {
		this.breakFix.setDelay(Integer.parseInt(delay));

		return this.breakFix;
	}

	public BreakFix fixSleeping() {
		this.breakFix.setDelay(BreakFix.NO_DELAY);

		return this.breakFix;
	}

	public BreakFix breaking(String message) {
		this.breakFix.setBrokenMessage(message);

		return this.breakFix;
	}

	public BreakFix fixBreaking() {
		this.breakFix.setBrokenMessage(null);

		return this.breakFix;
	}
	
	public BreakFix disabling() {
		this.breakFix.disabled();

		return this.breakFix;
	}

	public BreakFix.Status getStatus() {
		return this.breakFix.getStatus();
	}

	public void process() {
		if (BreakFix.Status.OK.equals(breakFix.getStatus())) {
			return; // Everything OK
		}

		if (BreakFix.Status.BROKEN.equals(breakFix.getStatus())) {
			LOGGER.warn("[BREAK & FIX] Ops!! This service is throwing a exception: {}", breakFix.getBrokenMessage());

			// Ops! a business exception
			throw new RuntimeException(breakFix.getBrokenMessage());
		}

		if (BreakFix.Status.DELAYED.equals(breakFix.getStatus())) {
			LOGGER.warn("[BREAK & FIX] Sleeping the request {} milliseconds", breakFix.getDelay());

			try {
				Thread.sleep(breakFix.getDelay());
			} catch (InterruptedException e) {
				// Nothing
			}
		}
	}

}
