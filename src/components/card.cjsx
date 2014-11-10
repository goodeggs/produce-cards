Velocity = require 'touch-velocity'

LEFT = -1
RIGHT = 1

NORMAL_SWIPE = 300 # px/s
FAST_SWIPE = 500


class Flipper
  intial: null    # x-coordinate of touchstart
  velocity: null
  displacement: 0 # current x-axis displacement since touchstart
  POINT_OF_NO_RETURN: 90

  maxRotation: 180
  rotation: 0     # in degrees from -180 to 180
  percent: 0  # percent rotated, from -1 to 1

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
    @percent = @clamp(1.6 * @displacement / @cardWidth)
    @rotation = (@percent * @maxRotation).toFixed(5)
    @_instant()
    @_sync()

  flip: ({direction}={}) ->
    direction ?= RIGHT
    @rotation = if direction < 0 then -@maxRotation else @maxRotation
    @_ease()
    @_sync()
    @onCompleted?()

  settle: ->
    velocity = @velocity.getVelocity()
    absRotation = Math.abs(@rotation)
    absVelocity = Math.abs velocity
    committed = velocity * @rotation > 0

    if Math.abs(@rotation) < 15
      @flip()
    else if absRotation >= @POINT_OF_NO_RETURN
      @flip direction: @rotation
    else if committed and (absRotation > 40 or absVelocity > NORMAL_SWIPE)
      @flip direction: @rotation
    else if absVelocity > FAST_SWIPE
      @flip direction: velocity
    else
      @reset()
      return false
    return true

  reset: ->
    @rotation = 0
    @percent = 0
    @intial = null
    @_ease()
    @_sync()

class Swiper
  intial: null    # x-coordinate of touchstart
  velocity: null
  displacement: 0 # current x-axis displacement since touchstart
  finalDisplacement: null
  POINT_OF_NO_RETURN: 90

  constructor: (@$el, {@onCompleted}={}) ->
    @velocity = new Velocity()
    @cardWidth = @$el.width()
    @finalDisplacement = @cardWidth * 2
    @POINT_OF_NO_RETURN = @cardWidth * 0.5

  _ease: (duration) ->
    @$el.css 'transition-duration', "#{duration}s"

  _instant: ->
    @$el.css 'transition-duration', '0s'

  _sync: ->
    @$el.css 'transform', "translateX(#{@displacement}px)"

  progress: (x) ->
    @intial ?= x
    @velocity.updatePosition x
    @displacement = (x - @intial).toFixed(5)
    @_instant()
    @_sync()

  swipe: ({direction, velocity}={}) ->
    defaultVelocity = FAST_SWIPE * 5
    direction ?= LEFT
    velocity ?= defaultVelocity
    velocity = Math.max(defaultVelocity, Math.abs velocity) * 1.5
    oldDisplacement = @displacement or 0
    @displacement = if direction < 0 then -@finalDisplacement else @finalDisplacement
    duration = Math.abs(@displacement - oldDisplacement) / velocity
    @_ease(duration)
    @_sync()
    @onCompleted?()

  settle: ->
    velocity = @velocity.getVelocity()
    absDisplacement = Math.abs @displacement
    absVelocity = Math.abs velocity
    committed = velocity * @displacement > 0

    if absDisplacement < 20
      @swipe()
    else if absDisplacement >= @POINT_OF_NO_RETURN
      @swipe {direction: @displacement, velocity}
    else if committed and (absDisplacement > (@POINT_OF_NO_RETURN / 3) or absVelocity > NORMAL_SWIPE)
      @swipe {direction: @displacement, velocity}
    else if absVelocity > FAST_SWIPE
      @swipe {direction: velocity, velocity}
    else
      @reset()

  reset: ->
    @displacement = 0
    @intial = null
    @_ease()
    @_sync()

Card = React.createClass

  propTypes:
    name: React.PropTypes.string.isRequired
    photoUrl: React.PropTypes.string.isRequired
    onCompleted: React.PropTypes.func
    onSwiped: React.PropTypes.func

  getInitialState: ->
    flipped: false
    swiped: false

  componentDidMount: ->
    @flipper = new Flipper jQuery(@refs.flipper.getDOMNode()),
      onCompleted: =>
        @setState flipped: true

    @swiper = new Swiper jQuery(@refs.swiper.getDOMNode()),
      onCompleted: @onSwipeCompleted

    @$el = jQuery @getDOMNode()
    @$el.swipe
      allowPageScroll: 'vertical'
      swipeStatus: @onSwipeStatus
      threshold: 0 # always swipe, never tap

  onSwipeCompleted: ->
    @setState swiped: true
    @props.onSwiped?()
    @$el.transitionEnd (event) =>
      return unless jQuery(event.target).hasClass 'card__swiper'
      @$el.off()
      @props.onCompleted?()

  onSwipeStatus: (event, phase, direction, distance) ->
    event.preventDefault?() # prevent veritcal scroll while swiping
    x = event.pageX or event.touches?[0]?.pageX
    animation = switch
      when not @state.flipped
        @flipper
      when not @state.swiped
        @swiper

    return unless animation

    switch phase
      when 'move'
        animation.progress x
      when 'end', 'cancel'
        animation.settle()

  render: ->
    cx = React.addons.classSet
    <div className="card">
      <div className={cx
        card__swiper: true
        swiped: @state.swiped
        '': true
      } ref="swiper">
      <div className={cx
             card__flipper: true
             flipped: @state.flipped
           } ref="flipper">
        <div className="card__front">
          <img className="card__image"
               draggable="false"
               src={@props.photoUrl} />
        </div>
        <div className="card__back">
          {@props.name}
        </div>
      </div>
      </div>
    </div>

module.exports = Card
