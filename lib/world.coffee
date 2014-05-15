request = require 'request'

WorldConstructor = (environment) ->
  return unless environment

  @browser = require('webdriverjs').remote(environment.webdriver)
  @baseUrl = environment.baseUrl

  @defaultTimeout = 5000

  @visit = (url, done) =>
    @browser.init().url(url, done)

  @setStatus = (data, done) =>
    if environment.type is 'sauce'
      @browser.session 'get', (err, rsp) ->
        return console.warn err if err
        console.log "SauceOnDemandSessionID=#{rsp.sessionId} job-name=#{data.name}"
        updateSession(data, rsp.sessionId, done)
    else done()

  updateSession = (data, session, done) ->
    host = "#{environment.webdriver.user}:#{environment.webdriver.key}@saucelabs.com"
    path = "/rest/v1/#{environment.webdriver.user}/jobs/#{session}"
    url = "https://#{host}#{path}"
    body = JSON.stringify(data)

    request.put {url: url, body: body}, (err, rsp) ->
      return console.warn err if err
      console.log rsp.statusCode
      done()


module.exports = WorldConstructor
