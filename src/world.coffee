request = require 'request'

World = (done, environment) ->

  [type, browser, version] = environment.split(':') if environment?.length

  type ?= 'local'
  browser ?= 'firefox'
  version ?= 'any'

  # TODO: find a better way to pass explorer
  browser = 'internet explorer' if browser == 'ie'

  env = require("./env-#{type}")(browser, version)
  @browser = require('webdriverjs').remote(env.webdriver)
  @baseUrl = env.baseUrl

  @defaultTimeout = 5000

  @visit = (url, done) =>
    @browser.init().url(url, done)

  @setStatus = (data, done) =>
    if type is 'sauce'
      @browser.session 'get', (err, rsp) ->
        return console.warn err if err
        console.log "SauceOnDemandSessionID=#{rsp.sessionId} job-name=#{data.name}"
        updateSession(data, rsp.sessionId, done)
    else done()

  updateSession = (data, session, done) ->
    host = "#{env.webdriver.user}:#{env.webdriver.key}@saucelabs.com"
    path = "/rest/v1/#{env.webdriver.user}/jobs/#{session}"
    url = "https://#{host}#{path}"
    body = JSON.stringify(data)

    request.put {url: url, body: body}, (err, rsp) ->
      return console.warn err if err
      console.log rsp.statusCode
      done()

  done() if done?


module.exports = World
