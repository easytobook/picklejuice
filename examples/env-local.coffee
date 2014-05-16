module.exports = (browserName) ->
  webdriver:
    host: '127.0.0.1'
    desiredCapabilities:
      browserName: browserName
    logLevel: 'silent'
  baseUrl: 'http://localhost:9000/'
