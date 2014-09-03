Polymer 'draught-player-list',
  roster: null
  filterDrafted: true
  searchText: ''
  search: (players, text) ->
    lower = text.toLowerCase()
    _.filter players, (p) -> _.contains(p.name.toLowerCase(), lower)
