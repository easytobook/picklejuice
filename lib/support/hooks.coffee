sanitize = require('sanitize-filename')

isScenario = (scenario) ->
  return scenario.payloadType is 'scenario'

Hooks = ->
  @Before (scenario, done) ->
    return done() unless isScenario(scenario)

    @passed = true
    done()

  @After (scenario, done) ->
    return done() unless isScenario(scenario)

    scenario.getSteps().syncForEach (step) =>
      isFailed = step.stepResult?.isFailed()
      @passed = false if isFailed
    data =
      passed: @passed
      name: scenario.getName()
    if @meta?
      console.log @meta
      data.name = data.name + " ID " + @meta.testId
      data["custom-data"] = @meta
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
