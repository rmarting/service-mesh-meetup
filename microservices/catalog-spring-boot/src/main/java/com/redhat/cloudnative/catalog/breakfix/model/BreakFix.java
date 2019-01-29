package com.redhat.cloudnative.catalog.breakfix.model;

import java.io.Serializable;

public class BreakFix implements Serializable {

	private static final long serialVersionUID = 3003762119510318597L;

	public static final int NO_DELAY = 0;

	public static enum Status {
		OK, BROKEN, DELAYED, NOT_READY;
	}

	private boolean ready = true;
	
	private int delay = NO_DELAY;

	private String brokenMessage;

	public int getDelay() {
		return delay;
	}

	public void setDelay(int delay) {
		if (delay < 0) {
			this.delay = NO_DELAY;
		}
		this.delay = delay;
	}

	public String getBrokenMessage() {
		return brokenMessage;
	}

	public void setBrokenMessage(String msg) {
		this.brokenMessage = msg;
	}
	
	public void disabled() {
		this.ready = false;
	}

	public Status getStatus() {
		if (this.delay != NO_DELAY) {
			return Status.DELAYED;
		}

		if (null != this.brokenMessage) {
			return Status.BROKEN;
		}
		
		if (!ready) {
			return Status.NOT_READY;
		}

		return Status.OK;
	}

	@Override
	public String toString() {
		return "BreakFix [delay='" + delay + 
				"', brokenMessage='" + brokenMessage + 
				"', ready='" + ready + 
				"', status='" + getStatus() + "']'";
	}

}
