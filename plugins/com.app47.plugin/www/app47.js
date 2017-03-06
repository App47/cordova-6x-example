/**
 * If you have any questions/comments please find us at http://app47.com or contact us support@app47.com
 */

var app47 = {
  
  sendGenericEvent: function(message, success, fail) {
    cordova.exec(success, fail, "App47", "sendGenericEvent", [message]);
  },

  genericEvent: function(message, success, fail) {
    cordova.exec(success, fail, "App47", "sendGenericEvent", [message]);
  },

  timedEvent: function(message, success, fail) {
     cordova.exec(function(id){  
        if(success){ 
          success.call(this, id);
        }
        cordova.exec(null, null, "App47", "endTimedEvent", [id]);
     }, fail, "App47", "startTimedEvent", [message]);
  },
  
  startTimedEvent: function(name, success, fail) {
    cordova.exec(success, fail, "App47", "startTimedEvent", [name]);
  },

  endTimedEvent: function(name, success, fail) {
    cordova.exec(success, fail, "App47", "endTimedEvent", [name]);
  },

  debug: function(message, success, fail) {
    cordova.exec(success, fail, "App47", "log", [{type:"debug", msg:message}]);
  },

  info: function(message, success, fail) {
    cordova.exec(success, fail, "App47", "log", [{type:"info", msg:message}]);
  },

  warn: function(message, success, fail) {
    cordova.exec(success, fail, "App47", "log", [{type:"warn", msg:message}]);
  },

  error: function(message, success, fail) {
    cordova.exec(success, fail, "App47", "log", [{type:"error", msg:message}]);
  },

  getValue: function(grp, ky, success, fail) {
    cordova.exec(success, fail, "App47", "configurationValue", [{group:grp, key:ky}]);
  },

  getConfiguration: function(grp, success, fail) {
    cordova.exec(success, fail, "App47", "configurationAsMap", [{group:grp}]);
  },

  getConfigurationKeys: function(grp, success, fail) {
    cordova.exec(success, fail, "App47", "configurationKeys", [{group:grp}]);
  },

  getConfigurationGroupNames: function(success, fail) {
    cordova.exec(success, fail, "App47", "configurationGroupNames", []);
  },

  configureAgent: function(appId, success, fail) {
    cordova.exec(success, fail, "App47", "configureAgent", appId);
  }

}

module.exports = app47;