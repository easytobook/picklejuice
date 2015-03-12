(function() {
  var PickleJuice, request;

  request = require('request');

  PickleJuice = function(environment) {
    var updateSession;
    if (!environment) {
      return;
    }
    this.browser = require('webdriverio').remote(environment.webdriver);
    this.baseUrl = environment.baseUrl;
    this.defaultTimeout = 5000;
    this.setStatus = (function(_this) {
      return function(data, done) {
        if (environment.type !== 'sauce') {
          return done();
        }
        return _this.browser.session('get', function(err, rsp) {
          if (err) {
            return console.warn(err);
          }
          console.log("SauceOnDemandSessionID=" + rsp.sessionId + " job-name=" + data.name);
          return updateSession(data, rsp.sessionId, done);
        });
      };
    })(this);
    return updateSession = function(data, session, done) {
      var body, host, path, url;
      host = "" + environment.webdriver.user + ":" + environment.webdriver.key + "@saucelabs.com";
      path = "/rest/v1/" + environment.webdriver.user + "/jobs/" + session;
      url = "https://" + host + path;
      body = JSON.stringify(data);
      return request.put({
        url: url,
        body: body
      }, function(err, rsp) {
        if (err) {
          return console.warn(err);
        }
        console.log(rsp.statusCode);
        return done();
      });
    };
  };

  module.exports = PickleJuice;

}).call(this);
