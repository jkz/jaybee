# Search
Template.search.events 
  "keyup input.search": (event) ->
    query = event.currentTarget.value
    if query then search query else clearSearch()
    return

# Search Results
Template.searchResults.events 
  "click a.add": (event) ->
    event.preventDefault()
    addToPlaylist event.currentTarget.dataset.trackId
    return

Template.searchResults.results = ->
  return Session.get("search_results")

Template.searchResults.length = (duration) ->
  return track_length(duration)