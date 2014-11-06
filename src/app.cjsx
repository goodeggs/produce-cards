require './globals'
Deck = require './components/deck'
EggService = require './services/egg_service'

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

  fetchEggs: ->
    EggService.fetch (err, eggs) =>
      @setState {eggs}

window.start = (selector) ->
  React.render <App />, document.querySelector(selector)
