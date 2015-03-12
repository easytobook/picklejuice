request = require 'request'

PickleJuice = (environment) ->
  return unless environment

  @browser = require('webdriverio').remote(environment.webdriver)
  @baseUrl = environment.baseUrl

  @defaultTimeout = 5000

  # Used in hooks to set saucelabs status
  @setStatus = (data, done) =>
    return done() unless environment.type is 'sauce'

    @browser.session 'get', (err, rsp) ->
      return console.warn err if err
      console.log "SauceOnDemandSessionID=#{rsp.sessionId} job-name=#{data.name}"
      updateSession(data, rsp.sessionId, done)

  updateSession = (data, session, done) ->
    host = "#{environment.webdriver.user}:#{environment.webdriver.key}@saucelabs.com"
    path = "/rest/v1/#{environment.webdriver.user}/jobs/#{session}"
    url = "https://#{host}#{path}"
    body = JSON.stringify(data)

    request.put {url: url, body: body}, (err, rsp) ->
      return console.warn err if err
      console.log rsp.statusCode
      done()


module.exports = PickleJuice
