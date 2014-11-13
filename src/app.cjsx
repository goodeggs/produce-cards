require './globals'
_ = require 'underscore'
Card = require './components/card'
AppHeader = require './components/app_header'
EggService = require './services/egg_service'

# Artificial foodhub-like menu item
allHub =
  slug: 'all'
  name: 'All Eggs'

App = React.createClass

  getInitialState: ->
    eggs: []
    index: -1
    visibleEggs: []
    foodhub: allHub

  componentDidMount: ->
    EggService.fetch (err, eggs) =>
      eggs = _(eggs).shuffle()
      @setState {eggs}
      @addNextEggCard()
      @addNextEggCard()

  loading: ->
    @state.eggs.length < 1

  foodhubs: ->
    if @loading() then []
    else [allHub].concat EggService.foodhubs()

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
        foodhubs={@foodhubs()} />
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
