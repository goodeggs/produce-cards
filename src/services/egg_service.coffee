_ = require 'underscore'

class EggService
  @hubs:
    hubhub:
      slug: 'hubhub'
      name: 'Hub Hub'
    sfbay:
      slug: 'sfbay'
      name: 'SF Bay'
    nola:
      slug: 'nola'
      name: 'New Orleans'
    nyc:
      slug: 'nyc'
      name: 'New York City'
    la:
      slug: 'la'
      name: 'Los Angeles'

  @hubFor: ({team, foodshed}) ->
    if team is 'Hub Hub'
      @hubs.hubhub
    else if foodshed of @hubs
      @hubs[foodshed]
    else
      slug: foodshed
      name: foodshed[0].toUpperCase() + foodshed[1...]

  @transform: (egg) =>
    id: egg._id
    name: egg.user.firstName
    foodshed: egg.foodshed
    team: egg.team
    foodhub: @hubFor egg
    photoUrl: "https://goodeggs2.imgix.net/#{egg.photo.key}?w=500&h=500&q=&fit=crop&crop=faces"

  @fetch: (done) ->

    jQuery.ajax "/eggs.json",
      dataType: 'json'
    .done (eggs) =>
      @eggs = eggs.map @transform
      done null, @eggs

  @foodhubs: ->
    hubs = _(@eggs).chain()
      .pluck 'foodhub'
      .sortBy 'name'
      .uniq false, ({slug}) -> slug
      .value()

module.exports = EggService
