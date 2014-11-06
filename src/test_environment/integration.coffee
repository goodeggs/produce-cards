require './base'

wd = require 'wd'
chai = require 'chai'
asPromised = require 'chai-as-promised'
colors = require 'chai-colors'
settings = require '../settings'

chai
  .use colors
  .use asPromised

asPromised.transferPromiseness = wd.transferPromiseness

before ->
  @browser = wd.promiseChainRemote()

  @browser
    .init
      browserName: settings.browser
    .configureHttp
      baseUrl: settings.devServerUrl()

after ->
  @browser.quit()

module.exports =

  # Usage:
  # @browser.waitFor asPromised =>
  #   @card.isDisplayed().should.eventually.eql false
  asPromised: (promiser) ->
    new wd.asserters.Asserter (browser, done) ->
      promiser().nodeify (err) -> done(null, not err)
