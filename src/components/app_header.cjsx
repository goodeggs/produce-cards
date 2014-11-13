AppHeader = React.createClass

  propTypes:
    foodhub: React.PropTypes.object.isRequired
    foodhubs: React.PropTypes.array.isRequired

  render: ->
    <header className="app-header">
      <i className="icon icon-logo-2 app-header__icon"/>
      <div className="app-header__cover">
        {@props.foodhub.name}
        <i className="icon icon-chevron-thin icon-down" />
      </div>
      <select className="app-header__select"
              value={@props.foodhub.slug}>{
        for foodhub in @props.foodhubs
          <option value={foodhub.slug}>{foodhub.name}</option>
      }</select>
    </header>

module.exports = AppHeader
