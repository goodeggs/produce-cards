{elementGone} = require './test_environment/integration'

describe 'faces', ->
  before ->
    @browser.get '/'
    @topCard = ->
      @browser.elementByCss '.card:last-child'

  it 'is titled', ->
    @browser.title().should.eventually.match /egg/i

  it 'loads an egg card', ->
    @browser.waitForElementByCssSelector '.card', 15000

  describe 'an egg card', ->
    before ->
      @card = @topCard()

    it 'flips when clicked', ->
      @card.click()
      .waitForElementByCssSelector '>', '.card__flipper.flipped', timeout: 3000

    it 'is tossed when clicked again', ->
      @card.click()
      .waitFor elementGone(@card), 3000

    it 'reveals the next card', ->
      @browser.waitForElementByCssSelector '.card'

  describe 'clicking the foodshed filter', ->
    before ->
      @select = @browser.elementByCss '.app-header__select'

    it 'reveals foodhubs', ->
      @select
        .waitForElementByCssSelector 'option[value="sfbay"]'
        .waitForElementByCssSelector 'option[value="nyc"]'

    it 'can choose a foodhub', ->
      @browser.elementByCss 'option[value="nyc"]'
        .click()

    it 'limits cards to eggs in the chosen hub', ->
      @browser.waitForElementByCssSelector '.card[data-foodhub="nyc"]'

