class Position
  @RB = 'RB'
  @WR = 'WR'
  @QB = 'QB'
  @TE = 'TE'
  @K = 'K'

  @values = () -> [@RB, @WR, @QB, @TE, @K]


class Player
  constructor: (@name, @position, @rank, @tier, @projectedPoints, @isDrafted) ->

  @fromRaw: (m) ->
    new Player(m['Player Name'],
               m['Position'],
               m['Rank'],
               m['Tier'],
               m['Avg 2014 Projected Points'],
               m['Drafted'] or false)

  toRaw: () ->
    'Player Name': @name
    'Position': @position
    'Rank': @rank
    'Tier': @tier
    'Avg 2014 Projected Points': @projectedPoints,
    'Drafted': @isDrafted


class PlayerChangesSubscription
  constructor: (@callback, @context, @ue) ->
    @ue.on('changed', @callback, @context)

  cancel: () ->
    @ue.off('changed', @callback, @context)


class Roster
  constructor: (@players) ->
    @ue = uevents.create()
    obs = new CompoundObserver
    _.forEach @players, (p) -> obs.addPath(p, 'isDrafted')
    obs.open (newVals, oldVals) =>
      changes = for i, val of oldVals
        @players[i]
      @ue.trigger 'changed', changes

  playerChangesListen: (callback, context) ->
    new PlayerChangesSubscription(callback, context, @ue)


getUrl = (url) ->
  new Promise (resolve, reject) ->
    req = new XMLHttpRequest
    req.open 'GET', url
    req.onload = () ->
      if req.status == 200
        resolve req.response
      else
        reject Error(req.statusText)
    req.onerror = () ->
      reject Error('network error')
    req.send()


storageName = 'draught-players'
roster = null


loadRoster = () ->
  if (roster)
    return Promise.resolve roster
  storageValue = window.localStorage[storageName]
  jsonFuture =
    if storageValue
      Promise.resolve storageValue
    else
      getUrl '2014-draft-info.json'
  jsonFuture.then (val) ->
    players = _.map(JSON.parse(val), (p) -> Player.fromRaw(p))
    roster = new Roster players
    roster.playerChangesListen save
    roster


save = () ->
  window.localStorage[storageName] =
      JSON.stringify(_.map(roster.players, (p) -> p.toRaw()))


@draught or= {}
@draught.players =
  Position: Position
  Player: Player
  Roster: Roster
  loadRoster: loadRoster
