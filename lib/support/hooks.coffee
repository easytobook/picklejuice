sanitize = require('sanitize-filename')

Hooks = ->
  @Before (scenario, done) ->
    @passed = true
    done()

  @After (scenario, done) ->
    scenario.getSteps().syncForEach (step) =>
      isFailed = step.stepResult?.isFailed()
      @passed = false if isFailed
    data =
      passed: @passed
      name: scenario.getName()
    @setStatus data, =>
      @browser.end(done) if @browser?


  # FIXME somehow scenario is not available?
  #@After '@screenshot', (scenario, done) ->
  @After '@screenshot', (done) ->
    return unless @browser
    # TODO: decide in what directory to write the screenshots
    #filename = './' + sanitize(scenario.getName()) + '.png'
    #filename = filename.replace(/\s+/gi, '_')

    filename = './foo.png'
    console.log '\r\nWriting screenshot to: ' + filename + '\r\n'
    @browser.saveScreenshot(filename, done)

module.exports = Hooks
