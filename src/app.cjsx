require './globals'
Deck = require './components/deck'
EggService = require './services/egg_service'

# Source code here
 # loadEggs
 # flipRequested: -> flip
 # nextEggRequested: -> nextEgg
 # -----
 # filter

App = React.createClass

  getInitialState: ->
    eggs: []
    selected: null

  componentDidMount: ->
    @fetchEggs()

  loading: ->
    @state.eggs.length < 1

  render: ->
    <Deck eggs={@state.eggs}
          selected={@state.selected} />

  # Actions
  fetchEggs: ->
    EggService.fetch (err, eggs) =>
      @setState {eggs}

services = {}

models = {}


window.start = (selector) ->
  React.render <App />, document.querySelector(selector)
