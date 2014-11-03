AppDispatcher = require './app_dispatcher'

describe 'AppDispatcher', ->
  beforeEach ->
    @dispatcher = new AppDispatcher()

  describe 'given a subscriber', ->
    beforeEach ->
      @listener = sinon.spy()
      @dispatcher.register @listener

    it 'sends actions', ->
      @dispatcher.dispatch {}
      @listener.should.have.been.called.once
