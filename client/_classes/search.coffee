class window.Search
  constructor: ->
    console.log "Search class"

  clearSearch: ->
    Session.set("search_results", null)