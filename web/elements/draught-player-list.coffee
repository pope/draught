Polymer
  is: 'draught-player-list'
  properties:
    roster: Object
    filterDrafted:
      type: Boolean
      value: true
    searchText:
      type: String
      value: ''
  search: (players, text) ->
    lower = text.toLowerCase()
    _.filter players, (p) -> _.contains(p.name.toLowerCase(), lower)
