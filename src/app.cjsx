require './globals'
Card = require './components/card'
EggService = require './services/egg_service'

App = React.createClass

  getInitialState: ->
    eggs: []
    index: -1
    visibleEggs: []

  componentDidMount: ->
    EggService.fetch (err, eggs) =>
      @setState {eggs}
      @addNextEggCard()
      @addNextEggCard()

  loading: ->
    @state.eggs.length < 1

  removeTopEggCard: ->
    @state.visibleEggs.pop()
    @setState @state

  addNextEggCard: ->
    if egg = @state.eggs[++@state.index]
      @state.visibleEggs.unshift egg
      @setState @state

  render: ->
    <div className="deck">{
      for egg in @state.visibleEggs
        <Card key={egg.email}
              onSwiped={@addNextEggCard}
              onCompleted={@removeTopEggCard}
              {...egg} />
    }</div>

window.start = (selector) ->
  React.render <App />, document.querySelector(selector)
