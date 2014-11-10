{elementGone} = require './test_environment/integration'

describe 'faces', ->
  before ->
    @browser.get '/'

  it 'is titled', ->
    @browser.title().should.eventually.match /egg/i

  it 'loads an egg card', ->
    @browser.waitForElementByCssSelector '.card', 10000

  describe 'an egg card', ->
    before ->
      @card = @browser.elementByCss('.card:last-child')

    it 'flips when clicked', ->
      @card.click()
      .waitForElementByCssSelector '>', '.card__flipper.flipped', timeout: 3000

    it 'is tossed when clicked again', ->
      @card.click()
      .waitFor elementGone(@card), 3000

    it 'reveals the next card', ->
      @browser.waitForElementByCssSelector '.card'
