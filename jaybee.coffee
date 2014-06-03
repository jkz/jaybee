@PlaylistTracks = new Meteor.Collection("playlist_tracks")

if Meteor.isClient
  # Search
  Template.search.events 
    "keyup input.search": (event) ->
      console.log "Input: ", event.currentTarget.value
      search event.currentTarget.value
      return

  # Search Results
  Template.searchResults.events 
    "click a": (event) ->
      event.preventDefault()
      addToPlaylist event.currentTarget.dataset.trackId
      return

  Template.searchResults.results = ->
    return Session.get("search_results")

  Template.searchResults.length = (duration) ->
    return track_length(duration)

  # Playlist
  Template.playlist.tracks = ->
    return PlaylistTracks.find {}, 
      sort: [["created_at", "asc"]]

  Template.playlist.length = (duration) ->
    return track_length(duration)

  # Controls
  Template.controls.events 
    "click [data-control=play]": (event) ->
      event.preventDefault()
      play()
      return

    "click [data-control=pause]": (event) ->
      event.preventDefault()
      togglePause()
      return

    "click [data-control=next]": (event) ->
      event.preventDefault()
      playNext()
      return

    "click [data-control=volume-up]": (event) ->
      event.preventDefault()
      volumeUp()
      return

    "click [data-control=volume-down]": (event) ->
      event.preventDefault()
      volumeDown()
      return

  Template.controls.now_playing = ->
    return Session.get("now_playing")

  Template.controls.length = (duration) ->
    return track_length(duration)

if Meteor.isServer
  Meteor.startup ->

play = ->
  track = Session.get("now_playing")

  # Set now_playing
  unless track
    track = nextTrack()
    Session.set("now_playing", track)

  # Play it
  SC.stream "/tracks/#{track.track_id}", (sound) ->
    # Stop anything thats playing
    soundManager.stopAll()
    
    # Set Session sound
    Session.set("now_playing_sound", sound)
    
    # Play it
    sound.play
      onfinish: playNext

  # Remove from playlist
  removeFromPlaylist track._id

playNext = ->
  # Clear the currently playing Session data
  clearPlaying()

  # Play's the next track 
  # if the Session data is empty.
  play()

clearPlaying = ->
  Session.set("now_playing", null)
  Session.set("now_playing_sound", null)

togglePause = ->
  now_playing_sound = Session.get("now_playing_sound")
  soundManager.togglePause(now_playing_sound.sID)

volumeUp = ->
  sound = Session.get("now_playing_sound")
  if sound
    sound = soundManager.getSoundById(sound.sID)
    volume = sound.volume
    if volume < 100
      sound.setVolume(volume + 10)

volumeDown = ->
  sound = Session.get("now_playing_sound")
  if sound
    sound = soundManager.getSoundById(sound.sID)
    volume = sound.volume
    if volume > 0
      sound.setVolume(volume - 10)

nextTrack = ->
  PlaylistTracks.findOne {},
    sort: [["created_at", "asc"]]

addToPlaylist = (track_id) ->
  SC.get "/tracks/#{track_id}", (track) ->
    PlaylistTracks.insert
      track_id: track.id
      title:    track.title
      duration: track.duration
      created_at: timestamp()

removeFromPlaylist = (id) ->
  PlaylistTracks.remove id

search = (search_query) ->
  console.log search_query
  page_size = 20
  SC.get "/tracks", 
    q: search_query,
    filter: "streamable", 
    limit: page_size, (tracks) ->
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