Velocity = require 'touch-velocity'

class Flipper
  intial: null    # x-coordinate of touchstart
  velocity: null
  displacement: 0 # current x-axis displacement since touchstart
  POINT_OF_NO_RETURN: 90

  maxRotation: 180
  rotation: 0     # in degrees from -180 to 180
  percent: 0  # percent rotated, from -1 to 1

  LEFT: -1
  RIGHT: 1

  constructor: (@$el, {@onCompleted}={}) ->
    @cardWidth = @$el.width()
    @velocity = new Velocity()

  clamp: (x) ->
    Math.min(Math.max(x, -1), 1)

  _ease: ->
    @$el.css 'transition-duration', '1.0s'

  _instant: ->
    @$el.css 'transition-duration', '0s'

  _sync: ->
    @$el.css 'transform', "rotateY(#{@rotation}deg)"

  progress: (x) ->
    @intial ?= x
    @velocity.updatePosition x
    @displacement = x - @intial
    oldRotation = @rotation
    @percent = @clamp(@displacement / @cardWidth)
    @rotation = (@percent * @maxRotation).toFixed(5)
    @_instant()
    @_sync()

  flip: ({direction}={}) ->
    direction ?= @RIGHT
    @rotation = if direction < 0 then -@maxRotation else @maxRotation
    @_ease()
    @_sync()
    @onCompleted?()

  settle: ->
    velocity = @velocity.getVelocity()
    absRotation = Math.abs(@rotation)
    absVelocity = Math.abs velocity
    committed = velocity * @rotation > 0

    console.log JSON.stringify {absVelocity, absRotation, committed}
    if absRotation >= @POINT_OF_NO_RETURN
      @flip direction: @rotation
    else if committed and (absRotation > 40 or absVelocity > 300)
      console.log 'thrown', (absRotation > 40 or absVelocity > 300)
      @flip direction: @rotation
    else if absVelocity > 500
      console.log 'rethrown'
      @flip direction: velocity
    else
      console.log 'not enough'
      @reset()
      return false
    return true

  reset: ->
    @rotation = 0
    @percent = 0
    @intial = null
    @_ease()
    @_sync()

  passedPointOfNoReturn: ->
    Math.abs(@rotation) >= 90

  onSwipeStatus: (event, phase, direction, distance) ->

Card = React.createClass

  propTypes:
    name: React.PropTypes.string.isRequired
    photoUrl: React.PropTypes.string.isRequired

  getInitialState: ->
    flipped: false;

  componentDidMount: ->
    @flipper = new Flipper jQuery(@refs.flipper.getDOMNode()),
      onCompleted: =>
        @setState flipped: true
    @$el = jQuery @getDOMNode()
    @$el.swipe
      allowPageScroll: 'vertical'
      swipeStatus: @onSwipeStatus
      tap: @onTap

  onTap: ->
    console.log 'tap'
    unless @state.flipped
      @flipper.flip()

  onSwipeStatus: (event, phase, direction, distance) ->
    unless @state.flipped
      switch phase
        when 'move'
          x = event.pageX or event.touches?[0].pageX
          @flipper.progress x
        when 'end'
          @flipper.settle() or event.preventDefault()

  render: ->
    cx = React.addons.classSet
    <div className="card">
      <div className={cx
              card__flipper: true
              flipped: @state.flipped
            }
            ref="flipper">
        <div className="card__front">
          <img draggable="false"
               src={@props.photoUrl} />
        </div>
        <div className="card__back">
          {@props.name}
        </div>
      </div>
    </div>

module.exports = Card
