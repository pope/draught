class TierSummary
  constructor: (@tier, @averagePoints, @remaining, @goneBy) ->

isDrafted = (p) => p.isDrafted
isNotDrafted = (p) => !p.isDrafted

Polymer 'draught-position-stats',
  roster: null
  position: ''
  nextPick: null

  created: () ->
    @summary = []

  attached: () ->
    @grouped_ = _.chain @roster.players
      .filter (p) => p.position == @position
      .groupBy (p) => p.tier
      .valueOf()
    @updateSummary_()
    @roster.playerChangesListen (players) =>
      @updateSummary_() if _.find players, (p) => p.position == @position

  updateSummary_: () ->
    @nextPick = null
    allUndrafted = _.filter @roster.players, isNotDrafted
    @summary = _.chain _.keys(@grouped_)
      .map (tier) =>
        tieredPlayers = @grouped_[tier]
        totalPlayers = tieredPlayers.length
        sum = _.reduce tieredPlayers, ((sum, p) -> sum + p.projectedPoints), 0
        avg = sum / totalPlayers
        totalDrafted = _.filter(tieredPlayers, isDrafted).length
        remaining = totalPlayers - totalDrafted
        goneBy = 0
        if remaining > 0
          @nextPick = _.find tieredPlayers, isNotDrafted if not @nextPick
          lastPlayer = _.findLast tieredPlayers, isNotDrafted
          goneBy = _.indexOf(allUndrafted, lastPlayer) + 1
        new TierSummary tier, avg, remaining, goneBy
      .sort (a, b) -> a.tier - b.tier
      .valueOf()
