DeckStore = require './deck_store'

describe 'DeckStore', ->

  describe '.peekAtTop', ->
    beforeEach ->
      DeckStore.reset [1..10].map ->
        foodhub:
          slug: 'nyc'
          name: 'NYC'

    it 'returns the number of eggs requested', ->
      DeckStore.peekAtTop(4).should.have.length 4
