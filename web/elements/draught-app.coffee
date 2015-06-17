Polymer
  is: 'draught-app'

  properties:
    roster: Object
    positions:
      value: draught.players.Position.values()
    errorMessage:
      value: ''

  attached: () ->
    draught.players.loadRoster()
      .then (r) => @roster = r
      .catch (e) =>
        console.error e
        @errorMessage = e
