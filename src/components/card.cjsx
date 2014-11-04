Card = React.createClass

  propTypes:
    name: React.PropTypes.string.isRequired
    photoUrl: React.PropTypes.string.isRequired

  getInitialState: ->
    flipped: false;

  render: ->
    cx = React.addons.classSet
    <div className="card"
         onClick={@onClick}>
      <div className={cx card__flipper: true, flipped: @state.flipped}>
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
