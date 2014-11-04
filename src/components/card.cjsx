Card = React.createClass

  propTypes:
    name: React.PropTypes.string.isRequired
    photoUrl: React.PropTypes.string.isRequired

  getInitialState: ->
    flipped: false;

  render: ->
    <div className="card"
         onClick={@onClick}>
      <div className={'card__flipper' + if @state.flipped then ' flipped' else ''}>
        <img className="card__front"
             src={@props.photoUrl} />
        <div className="card__back">
          {@props.name}
        </div>
      </div>
    </div>

  onClick: ->
    @setState flipped: not @state.flipped

module.exports = Card
