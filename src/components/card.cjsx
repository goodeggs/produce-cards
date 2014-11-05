class Flipper
  rotation: 0
  maxRotation: 180
  flipped: false

  constructor: (@$el) ->
    @cardWidth = @$el.width()

  clamp: (x) ->
    Math.min(Math.max(x, -1), 1)

  _ease: ->
    @$el.css 'transition-duration', '0.8s'

  _instant: ->
    @$el.css 'transition-duration', '0s'

  _sync: ->
    @$el.css 'transform', "rotateY(#{@rotation}deg)"

  progress: (x) ->
    @rotation = (@clamp(x) * @maxRotation).toFixed(5)
    @_instant()
    @_sync()

  complete: ->
    @rotation = if @rotation < 0 then -@maxRotation else @maxRotation
    @flipped = true
    @_ease()
    @_sync()

  reset: ->
    @rotation = 0
    @_ease()
    @_sync()

  onSwipeStatus: (event, phase, direction, distance) ->
    switch phase
      when 'move'
        return unless direction in ['left', 'right']
        @progress (distance / @cardWidth) * (direction is 'left' and -1 or 1)
      when 'end'
        @complete()
      when 'cancel'
        @reset()

Card = React.createClass

  propTypes:
    name: React.PropTypes.string.isRequired
    photoUrl: React.PropTypes.string.isRequired

  getInitialState: ->
    flipped: false;

  componentDidMount: ->
    @flipper = new Flipper jQuery @refs.flipper.getDOMNode()
    @$el = jQuery @getDOMNode()
    @$el.swipe
      allowPageScroll: 'vertical'
      swipeStatus: @onSwipeStatus
      tap: @onTap

  onTap: ->
    unless @flipper.flipped
      @flipper.complete()

  onSwipeStatus: (event, phase, direction, distance) ->
    unless @flipper.flipped
      @flipper.onSwipeStatus arguments...

  render: ->
    <div className="card">
      <div className="card__flipper"}
          ref="flipper">
        <img className="card__front"
             draggable="false"
             src={@props.photoUrl} />
        <div className="card__back">
          {@props.name}
        </div>
      </div>
    </div>

module.exports = Card
