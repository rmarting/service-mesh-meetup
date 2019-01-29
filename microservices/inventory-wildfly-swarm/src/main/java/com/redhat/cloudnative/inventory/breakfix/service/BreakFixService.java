package com.redhat.cloudnative.inventory.breakfix.service;

import javax.inject.Named;
import javax.inject.Singleton;

import org.jboss.logging.Logger;

import com.redhat.cloudnative.inventory.breakfix.model.BreakFix;

@Singleton
@Named
public class BreakFixService {

	private static final Logger LOGGER = Logger.getLogger(BreakFixService.class);

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
			LOGGER.warnv("[BREAK & FIX] Ops!! This service is throwing a exception: {0}", breakFix.getBrokenMessage());
			
			// Ops! a business exception
			throw new RuntimeException(breakFix.getBrokenMessage()); 
		}
		
		if (BreakFix.Status.DELAYED.equals(breakFix.getStatus())) {
			LOGGER.warnv("[BREAK & FIX] Sleeping the request {0} milliseconds", breakFix.getDelay());
			
			try {
				Thread.sleep(breakFix.getDelay());
			} catch (InterruptedException e) {
				// Nothing
			}
		}
	}

}
