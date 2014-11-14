require './globals'
_ = require 'underscore'
Card = require './components/card'
AppHeader = require './components/app_header'
EggService = require './services/egg_service'
DeckStore = require './stores/deck_store'

VISIBLE_CARDS = 4

# Artificial foodhub-like menu item
allHub =
  slug: 'all'
  name: 'All Eggs'

App = React.createClass

  getInitialState: ->
    eggs: []
    foodhub: allHub

  componentDidMount: ->
    EggService.fetch (err, eggs) =>
      @redeal eggs

  redeal: (eggs) ->
    DeckStore.reset eggs
    DeckStore.shuffle()
    @setState eggs: DeckStore.peekAtTop VISIBLE_CARDS

  foodhubs: ->
    if DeckStore.isEmpty() then []
    else [allHub].concat EggService.foodhubs()

  onCardCompleted: ->
    DeckStore.discardTopCard()
    @setState eggs: DeckStore.peekAtTop VISIBLE_CARDS

  filter: (foodhubSlug) ->
    console.log 'filtering!', foodhubSlug, EggService.eggsIn(foodhubSlug).length
    if foodhubSlug is 'all'
      eggs = EggService.eggs
      foodhub = allHub
    else
      eggs = EggService.eggsIn foodhubSlug
      foodhub = EggService.hubs[foodhubSlug]

    @setState {foodhub}
    @redeal eggs

  render: ->
    <div>
      <AppHeader
        foodhub={@state.foodhub}
        foodhubs={@foodhubs()}
        onFoodhubSelected={@filter}/>
      <div className="deck">{
        for egg in @state.eggs
          <Card key={egg.id}
                onCompleted={@onCardCompleted}
                {...egg} />
      }</div>
    </div>

window.start = (selector) ->
  React.render <App />, document.querySelector(selector)
