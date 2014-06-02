@PlaylistTracks = new Meteor.Collection("playlist_tracks")

if Meteor.isClient
  Template.search.events 
    "keypress input.search": (event) ->
      search event.currentTarget.value
      return

  Template.searchResults.events 
    "click a": (event) ->
      event.preventDefault()
      addToPlaylist event.currentTarget.dataset.trackId
      return

  # Search Results
  Template.searchResults.results = ->
    return Session.get("search_results")

  Template.searchResults.length = (duration) ->
    duration_string = track_length(duration)
    return duration_string

  # Playlist
  Template.playlist.tracks = ->
    return PlaylistTracks.find {}, 
      sort: [["created_at", "asc"]]

  Template.playlist.length = (duration) ->
    duration_string = track_length(duration)
    return duration_string

if Meteor.isServer
  Meteor.startup ->

addToPlaylist = (track_id) ->
  SC.get "/tracks/#{track_id}", (track) ->
    console.log track
    PlaylistTracks.insert
      track_id: track.id
      title:    track.title
      duration: track.duration
      created_at: timestamp()

search = (search_query) ->
  SC.get "/tracks", q: search_query, (tracks) ->
    Session.set("search_results", tracks)

track_length = (duration) ->
  seconds = parseInt((duration/1000)%60)
  minutes = parseInt((duration/(1000*60))%60)
  hours   = parseInt((duration/(1000*60*60))%24)

  hours   = if hours < 10 then "0" + hours else hours
  minutes = if minutes < 10 then "0" + minutes else minutes
  seconds = if seconds < 10 then "0" + seconds else seconds
  
  duration_string = ""
  duration_string += "#{hours}:" unless hours == "00"
  duration_string += "#{minutes}:#{seconds}"

  return duration_string

timestamp = () ->
  new Date()