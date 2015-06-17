Polymer
  is: 'draught-player'
  properties:
    player: Object

  # TODO(pope): Maybe move to a filters mixin.
  toFixed: (num, precision) ->
    num.toFixed precision
