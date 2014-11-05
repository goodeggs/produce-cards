require './test_environment/integration'

describe 'faces', ->
  before ->
    @browser.get '/'

  it 'is titled', ->
    @browser.title().should.eventually.match /egg/i

