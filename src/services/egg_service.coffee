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

  @transform: (product) =>
    id: product._id
    name: product.name
    foodshed: 'nyc'
    photoUrl: "https:#{product.standardPhotoUrl}"

  @fetch: (done) ->
    jQuery.ajax '/products.json',
      dataType: 'json'
    .done (sections) =>
      products = _(sections)
        .chain()
        .pluck('listings')
        .flatten()
        .value()
      @products = products.map @transform
      done null, @products

module.exports = EggService
