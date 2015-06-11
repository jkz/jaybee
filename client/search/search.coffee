# Search
Template.search.events
  "keyup input.search": (event) ->
    query = event.currentTarget.value
    if query then player.search(query) else search.clearSearch()
    # if query then player.searchVideo(query) else search.clearSearch()

# Search Results
Template.searchResults.events 
  "click a.add": (event) ->
    event.preventDefault()
    track_id = event.currentTarget.dataset.trackId
    console.log track_id
    player.addToPlaylist(track_id)
    return

Template.searchResults.helpers
  results: ->
    return Session.get("search_results")

  length: (duration) ->
    return player.track_length(duration)