require './test_environment/integration'

describe 'faces', ->
  before ->
    @browser.get '/'

  it 'is titled', ->
    @browser.title().should.eventually.match /egg/i

  it 'loads an egg card', ->
    @browser.waitForElementByCssSelector '.card'

  it 'flips clicked cards', ->
    @browser
      .elementByCss('.card').click()
      .waitForElementByCssSelector '.card__flipper.flipped', timeout: 3000
