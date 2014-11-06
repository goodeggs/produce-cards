class Flipper
  rotation: 0
  delta: 0
  maxRotation: 180

  constructor: (@$el) ->
    @cardWidth = @$el.width()

  clamp: (x) ->
    Math.min(Math.max(x, -1), 1)

  _ease: ->
    @$el.css 'transition-duration', '1.0s'

  _instant: ->
    @$el.css 'transition-duration', '0s'

  _sync: ->
    @$el.css 'transform', "rotateY(#{@rotation}deg)"

  progress: (x) ->
    oldRotation = @rotation
    @rotation = (@clamp(x) * @maxRotation).toFixed(5)
    @delta = @rotation - oldRotation
    @_instant()
    @_sync()

  complete: ->
    @rotation = if @delta < 0 then -@maxRotation else @maxRotation
    @_ease()
    @_sync()

  reset: ->
    @rotation = 0
    @_ease()
    @_sync()

  onSwipeStatus: (event, phase, direction, distance) ->

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
    unless @state.flipped
      @completeFlip()

  onSwipeStatus: (event, phase, direction, distance) ->
    unless @state.flipped
      switch phase
        when 'move'
          return unless direction in ['left', 'right']
          @flipper.progress (distance / @flipper.cardWidth) * (direction is 'left' and -1 or 1)
        when 'end'
          @completeFlip()
        when 'cancel'
          @flipper.reset()

  completeFlip: ->
    @flipper.complete()
    @setState flipped: true

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
