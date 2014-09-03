Polymer 'draught-app',
  roster: null
  positions: draught.players.Position.values()
  errorMessage: ''
  attached: () ->
    draught.players.loadRoster()
      .then (r) => @roster = r
      .catch (e) => @errorMessage = e
