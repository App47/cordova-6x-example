package com.app47.pgplugin;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Map;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.app47.embeddedagent.EmbeddedAgent;
import com.app47.embeddedagent.EmbeddedAgentLogger;

public class App47PGPlugin extends CordovaPlugin {

	private static final String TYPE = "type";
	private static final String MSG = "msg";
	private static final String KEY = "key";
	private static final String GROUP = "group";
	private static final String ERROR = "error";
	private static final String WARN = "warn";
	private static final String INFO = "info";

	private static final String CONFIGURATION_GROUP_NAMES = "configurationGroupNames";
	private static final String CONFIGURATION_KEYS = "configurationKeys";
	private static final String END_TIMED_EVENT = "endTimedEvent";
	private static final String SEND_GENERIC_EVENT = "sendGenericEvent";
	private static final String CONFIGURATION_AS_MAP = "configurationAsMap";
	private static final String CONFIGURATION_VALUE = "configurationValue";
	private static final String START_TIMED_EVENT = "startTimedEvent";
	private static final String CONFIGURE_AGENT = "configureAgent";

	public boolean execute(final String method, final JSONArray args, final CallbackContext callback) throws JSONException {
		if (method.equals(START_TIMED_EVENT)) {
			return startTimedEvent(args, callback);
		} else if (method.equals(END_TIMED_EVENT)) {
			return endTimedEvent(args, callback);
		} else if (method.equals(SEND_GENERIC_EVENT)) {
			return genericEvent(args, callback);
		} else if (method.equals(CONFIGURATION_VALUE)) {
			final Object value = handleConfigurationValue(args);
			handleCallback(callback, value);
			return true;
		} else if (method.equals(CONFIGURATION_AS_MAP)) {
			final Map<String, String> value = handleConfigurationAsMap(args);
			if (value != null) {
				handleCallback(callback, new JSONObject(value));
			} else {
				handleCallback(callback, null);
			}
			return true;
		} else if (method.equals(CONFIGURATION_KEYS)) {
			handleCallback(callback, handleConfigurationKeys(args));
			return true;
		} else if (method.equals(CONFIGURATION_GROUP_NAMES)) {
			handleGroupNames(callback);
			return true;
		} else if (method.equals(CONFIGURE_AGENT)) {
			handleConfigureAgent(args, callback);
			return true;
		} else {
			return handleActionWithCallback(method, args, callback);
		}
	}

	private void handleConfigureAgent(final JSONArray args, final CallbackContext callback) throws JSONException {
		EmbeddedAgent.configureAgentWithAppID(cordova.getActivity().getApplicationContext(), args.getString(0));
		EmbeddedAgent.onResume(cordova.getActivity().getApplicationContext());
		handleCallback(callback, "success");
	}

	private void handleGroupNames(final CallbackContext callback) {
		final String[] value = EmbeddedAgent.configurationGroupNames();
		final Collection<String> collection = new ArrayList<String>(Arrays.asList(value));
		handleCallback(callback, new JSONArray(collection));
	}

	private void handleCallback(final CallbackContext callback, final Object value) {
		if (value != null) {
			callback.success(value.toString());
		} else {
			callback.error("null value received");
		}
	}

	private boolean handleActionWithCallback(final String method, final JSONArray args, final CallbackContext callback) {
		try {
			if (log(args)) {
				callback.success();
				return true;
			} else {
				callback.error("there was an error!");
				return false;
			}
		} catch (JSONException e) {
			callback.error("there was an error: " + e.getLocalizedMessage());
			return false;
		}
	}
	
	private Map<String, String> handleConfigurationAsMap(final JSONArray data) throws JSONException {
		final JSONObject values = data.getJSONObject(0);
		final String group = values.getString(GROUP);
		return EmbeddedAgent.configurationGroupAsMap(group);
	}

	private Object handleConfigurationKeys(final JSONArray data) throws JSONException {
		final JSONObject values = data.getJSONObject(0);
		final String group = values.getString(GROUP);
		return EmbeddedAgent.allKeysForConfigurationGroup(group);
	}

	private Object handleConfigurationValue(final JSONArray data) throws JSONException {
		final JSONObject values = data.getJSONObject(0);
		final String group = values.getString(GROUP);
		final String key = values.getString(KEY);
		return EmbeddedAgent.configurationObjectForKey(key, group);
	}

	private boolean endTimedEvent(final JSONArray data, final CallbackContext callback) throws JSONException {
		try {
			final String udid = data.getString(0);
			EmbeddedAgent.endTimedEvent(udid);
			callback.success(udid);
		} catch (JSONException e) {
			callback.error("there was an error: " + e.getLocalizedMessage());
		}
		return true;
	}

	private boolean startTimedEvent(final JSONArray data, final CallbackContext callback) throws JSONException {
		cordova.getThreadPool().execute(new Runnable() {
			public void run() {
				try {
					final String udid = EmbeddedAgent.startTimedEvent(data.getString(0));
					callback.success(udid);
				} catch (JSONException e) {
					callback.error("there was an error: " + e.getLocalizedMessage());
				}
			}
		});
		return true;
	}

	private boolean log(final JSONArray data) throws JSONException {
		final JSONObject values = data.getJSONObject(0);
		final String logLevel = values.getString(TYPE);
		final String message = values.getString(MSG);
		if (logLevel.equals(INFO)) {
			EmbeddedAgentLogger.info(message);
		} else if (logLevel.equals(WARN)) {
			EmbeddedAgentLogger.warn(message);
		} else if (logLevel.equals(ERROR)) {
			EmbeddedAgentLogger.error(message);
		} else { // debug
			EmbeddedAgentLogger.debug(message);
		}
		return true;
	}

	private boolean genericEvent(final JSONArray data, final CallbackContext callback) {
		cordova.getThreadPool().execute(new Runnable() {
			public void run() {
				try {
					EmbeddedAgent.sendEvent(data.getString(0));
					callback.success();
				} catch (JSONException e) {
					callback.error(e.getLocalizedMessage());
				}
			}
		});
		return true;
	}
}