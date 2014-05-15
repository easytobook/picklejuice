_ = require('underscore')

class BaseView
  constructor: (@world) ->
    # FIXME: Sometimes the constructor is called without arguments
    if @world?.browser?
      @browser = @world.browser

  open: (done) ->
    # Create partial that binds the correct done callback
    waitIfNeeded = _(@waitIfNeeded).bind(this, done)

    if @url
      @world.visit(@world.baseUrl + @url, waitIfNeeded)
    else
      # If View doesn't have a @url wait for it to be ready, or open a new
      # browser session to the root view in case there are no open sessions.
      if @browser.sessionId
        waitIfNeeded()
      else
        @world.visit(@world.baseUrl, waitIfNeeded)

  waitIfNeeded: (done) ->
    return done() unless @waitFor

    @browser.waitFor(@waitFor, @world.defaultTimeout, done)


module.exports = BaseView
