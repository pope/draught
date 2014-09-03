Polymer 'draught-draft-stats',
  roster: null
  computed:
    total: 'updateTotal_(totals)'

  created: () ->
    @totals = {}

  attached: () ->
    _.forEach draught.players.Position.values(), (v) => @totals[v] = 0
    _.chain @roster.players
      .where (p) -> p.isDrafted
      .forEach (p) => @totals[p.position]++
    @totals = _.clone(@totals)
    @roster.playerChangesListen (players) =>
      _.forEach players, (p) =>
        if p.isDrafted
          @totals[p.position]++
        else
          @totals[p.position]--
      @totals = _.clone(@totals)

  updateTotal_: (totals) ->
    _.reduce _.values(totals), ((a, b) -> a + b), 0
