class EggService
  @transform: (egg) ->
    id: egg._id
    name: egg.user.firstName
    foodshed: egg.foodshed
    team: egg.team
    photoUrl: "https://goodeggs2.imgix.net/#{egg.photo.key}?w=500&h=500&q=&fit=crop&crop=faces"

  @fetch: (done) ->
    jQuery.ajax "/eggs.json",
      dataType: 'json'
    .done (eggs) =>
      console.log 'done!'
      done null, eggs.map @transform

module.exports = EggService
