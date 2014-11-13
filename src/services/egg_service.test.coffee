EggService = require './egg_service'

describe 'EggService', ->

  describe '.hubFor', ->

    describe 'given an egg on the hub hub team', ->
      it 'returns hub hub', ->
        EggService.hubFor(team: 'Hub Hub', foodshed: 'sfbay')
          .slug.should.equal 'hubhub'

    describe 'given an egg on a foodhub team', ->
      it 'returns their foodsheds hub', ->
        EggService.hubFor(team: 'Foodhub', foodshed: 'nyc')
          .slug.should.equal 'nyc'

      describe 'in a newly discovered foodshed', ->
        it 'returns a generated hub', ->
          hub = EggService.hubFor(team: 'Foodhub', foodshed: 'portlandia')
          hub.slug.should.equal 'portlandia'
          hub.name.should.equal 'Portlandia'
