Card = React.createClass

  propTypes:
    name: React.PropTypes.string.isRequired

  render: ->
    <div>{@props.name}</div>

module.exports = Card
