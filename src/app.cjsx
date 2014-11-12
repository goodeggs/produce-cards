require './globals'
_ = require 'underscore'
Card = require './components/card'
AppHeader = require './components/app_header'
EggService = require './services/egg_service'

foodhubs = [
  {slug: 'all', name: 'All Eggs'}
]

App = React.createClass

  getInitialState: ->
    eggs: []
    index: -1
    visibleEggs: []
    foodhub: foodhubs[0]
    foodhubs: foodhubs

  componentDidMount: ->
    EggService.fetch (err, eggs) =>
      eggs = _(eggs).shuffle()
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
    <div>
      <AppHeader
        foodhub={@state.foodhub}
        foodhubs={@state.foodhubs} />
      <div className="deck">{
        for egg in @state.visibleEggs
          <Card key={egg.id}
                onSwiped={@addNextEggCard}
                onCompleted={@removeTopEggCard}
                {...egg} />
      }</div>
    </div>

window.start = (selector) ->
  React.render <App />, document.querySelector(selector)
