@PlaylistTracks = new Meteor.Collection("playlist_tracks")

if Meteor.isClient
  # Search
  Template.search.events 
    "keyup input.search": (event) ->
      query = event.currentTarget.value
      if query then search query else clearSearch()
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
    return PlaylistTracks.find {now_playing: false}, 
      sort: [["created_at", "asc"]]

  Template.playlist.length = (duration) ->
    return track_length(duration)

  # Controls
  Template.controls.events 
    "click [data-control=play]": (event) ->
      event.preventDefault()
      Meteor.call('play')
      return

    "click [data-control=pause]": (event) ->
      event.preventDefault()
      Meteor.call('togglePause')
      return

    "click [data-control=next]": (event) ->
      event.preventDefault()
      Meteor.call('playNext')
      return

    "click [data-control=volume-up]": (event) ->
      event.preventDefault()
      Meteor.call('volumeUp')
      return

    "click [data-control=volume-down]": (event) ->
      event.preventDefault()
      Meteor.call('volumeDown')
      return

    "click [data-control=mute]": (event) ->
      event.preventDefault()
      Meteor.call('toggleMute')
      return

    # Controls
    Template.controls.now_playing = ->
      return Meteor.call('nowPlaying')

    Template.controls.length = (duration) ->
      return track_length(duration)

    Template.controls.elapsed = ->
      position = Session.get("local_track_position")
      if position
        return track_length Session.get("local_track_position")
      else
        return

if Meteor.isServer
  Meteor.startup ->

Meteor.methods
  play: ->
    console.log "Play!"
    track = Meteor.call('nowPlaying')

    # Set now_playing
    unless track
      track = Meteor.call('nextTrack')
      console.log("1:", track)
      Meteor.call('markAsNowPlaying', track)
      console.log("2:", track)

    # Play it
    SC.stream "/tracks/#{track.track_id}", (sound) ->    
      # Set Session sound
      Session.set("now_playing_sound", sound)

      # Start playing the track
      console.log "About to Play!"
      sound.play
        onfinish: ->
          Mateor.call('unload')
          Mateor.call('playNext')
        whileplaying: ->
          console.log "PLAYINGGGGGG!"
          Meteor.call('elapsed', @position)
          @onPosition 30000, ->
            Meteor.call('playNext')

  playNext: ->
    # Stop anything thats playing
    soundManager.stopAll()

    # Clear the currently playing Session data
    Meteor.call('clearPlaying')

    # Play's the next track 
    # if the Session data is empty.
    Meteor.call('play')

  elapsed: (position) ->
    track = Meteor.call('nowPlaying')
    Session.set("local_track_position", position)
    # updateTime(track, position)

  # updateTime = (track, position) ->
  #   # Only update the track position if
  #   # we're the only client up to date/on-time.
  #   if position > track.position
  #     # console.log("updating time to #{position}")
  #     PlaylistTracks.update track._id,
  #       $set:
  #         position: position

  nowPlaying: ->
    # PlaylistTracks.findOne({now_playing: true}, {sort: [["created_at", "asc"]]})
    PlaylistTracks.findOne {now_playing: true},
      sort: [["created_at", "asc"]]

  markAsNowPlaying: (track) ->
    # PlaylistTracks.update(track._id, {$set: {now_playing: true}})
    PlaylistTracks.update track._id,
      $set:
        now_playing: true

  nextTrack: ->
    # PlaylistTracks.findOne({now_playing: false}, {sort: [["created_at", "asc"]]})
    PlaylistTracks.findOne {now_playing: false}, 
      sort: [["created_at", "asc"]]

  clearPlaying: ->
    # Clear Sound Manager sound from session
    Session.set("now_playing_sound", null)

    # Clear local time position
    Session.set("local_track_position", null)

    # Mark track as not playing
    track = Meteor.call('nowPlaying')
    PlaylistTracks.remove track._id

  togglePause: ->
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

toggleMute = ->
  sound = Session.get("now_playing_sound")
  if sound
    sound = soundManager.getSoundById(sound.sID)
    volume = sound.volume
    if volume is 0
      pre_mute_volume = Session.get("pre_mute_volume") || 80
      sound.setVolume(pre_mute_volume)
    else
      Session.set("pre_mute_volume", volume)
      sound.setVolume(0)

addToPlaylist = (track_id) ->
  SC.get "/tracks/#{track_id}", (track) ->
    PlaylistTracks.insert
      track_id: track.id
      title:    track.title
      username: track.user.username
      duration: track.duration
      artwork_url: track.artwork_url
      position: 0
      now_playing: false
      created_at: timestamp()

search = (search_query) ->
  page_size = 20
  SC.get "/tracks", 
    q: search_query,
    filter: "streamable", 
    limit: page_size, (tracks) ->
      Session.set("search_results", tracks)

clearSearch = ->
  Session.set("search_results", null)  

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

timestamp = ->
  new Date()