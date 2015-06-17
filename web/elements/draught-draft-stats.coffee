class PositionStats
  constructor: (@position, @totalDrafted) ->

Polymer
  is: 'draught-draft-stats'

  properties:
    roster: Object
    total: Number
    stats: Array

  attached: () ->
    positions = draught.players.Position.values()
    defaults = _.reduce positions, ((obj, v) -> obj[v] = 0; obj), {}
    @stats = _.chain @roster.players
      .filter 'isDrafted'
      .groupBy 'position'
      .mapValues 'length'
      .defaults defaults
      .transform ((res, num, key) -> res.push new PositionStats(key, num)), []
      .sort (a, b) ->
        _.indexOf(positions, a.position) - _.indexOf(positions, b.position)
      .valueOf()
    @total = _.reduce @stats, ((sum, s) -> sum + s.totalDrafted), 0
    @roster.playerChangesListen (players) =>
      _.forEach players, (p) =>
        idx = _.findIndex @stats, (s) => s.position == p.position
        stat = @stats[idx]
        if p.isDrafted
          @total++
          stat.totalDrafted++
        else
          @total--
          stat.totalDrafted--
        this.notifyPath("stats.#{idx}.totalDrafted", stat.totalDrafted);
