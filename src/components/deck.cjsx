Card = require './card'

Deck = React.createClass

  propTypes:
    eggs: React.PropTypes.array.isRequired

  render: ->
    <div>{
      for egg in @props.eggs
        <Card key={egg.email} {...egg} />
    }</div>

module.exports = Deck
