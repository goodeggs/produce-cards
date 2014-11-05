convict = require 'convict'

conf = convict
  port:
    doc: "Localhost port dev server should listen on"
    format: 'port'
    default: 8000
    env: 'PORT'

  seleniumServer:
    port:
      format: 'port'
      default: 4444
      env: 'SELENIUM_SERVER_PORT'

  browser:
    doc: "Run tests in this browser"
    format: ['chrome', 'firefox', 'phantomjs']
    default: 'chrome'
    env: 'BROWSER'

  watch:
    doc: "Rebuild assets when files change"
    format: Boolean
    default: false
    env: 'WATCH'

.validate()

module.exports = conf.get()

module.exports.devServerUrl = ->
  "http://localhost:#{@port}"
