_ = require 'underscore'

module.exports =

  eggs: []

  shuffle: ->
    @eggs = _(@eggs).shuffle()

  discardTopCard: ->
    @eggs.pop()

  peekAtTop: (count) ->
    _(@eggs).last count

  reset: (@eggs) ->

  isEmpty: ->
    @eggs.length < 1

