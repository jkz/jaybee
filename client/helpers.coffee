# Functions
#
# window.play = (id) ->
#   track = PlaylistTracks.findOne id

#   # Play it
#   SC.stream "/tracks/#{track.track_id}", (sound, error) ->
#     # Stop anything thats playing
#     soundManager.stopAll()

#     # Start playing the track
#     sound.play
#       onfinish: playNext
#       whileplaying: ->
#         elapsed id, @position
#       onload: ->
#         if @readyState == 2
#           console.warn "There was a problem with the track.", @
#           playNext()

# window.playNext = ->
#   # Add to history
#   addToHistory()

#   # Clear the currently playing Session data
#   clearPlaying()

#   track = nextTrack()

#   if track
#     markAsNowPlaying track
#   else
#     console.log "Add a track to the playlist"

# window.elapsed = (id, position) ->
#   track = PlaylistTracks.findOne id

#   if position > track.position
#     PlaylistTracks.update track._id,
#       $set:
#         position: position

#   elapsed_time = track_length position
#   Session.set "local_elapsed_time", elapsed_time

# window.clearPlaying = ->
#   # Mark track as not playing
#   track = nowPlaying()
#   if track
#     PlaylistTracks.remove(track._id)
#   # console.log("Now playing (should be null): ", nowPlaying())

# window.addToHistory = ->
#   track = nowPlaying()
#   if track
#     PlayedTracks.insert
#       track_id: track.track_id
#       added_by: Meteor.user()
#       upVotes: track.upVotes
#       downVotes: track.downVotes
#       created_at: new Date()

# window.upVote = ->
#   track = nowPlaying()
#   user_id = Meteor.user()._id
#   PlaylistTracks.update track._id,
#     $addToSet:
#       upVotes: user_id
#     $pull: 
#       downVotes: user_id

# window.downVote = ->
#   track = nowPlaying()
#   user_id = Meteor.user()._id
#   PlaylistTracks.update track._id,
#     $addToSet:
#       downVotes: user_id
#     $pull: 
#       upVotes: user_id

# window.nextTrack = ->
#   # PlaylistTracks.findOne({now_playing: false}, {sort: [["created_at", "asc"]]})
#   PlaylistTracks.findOne {now_playing: false}, 
#     sort: [["created_at", "asc"]]

# window.nowPlaying = ->
#   # PlaylistTracks.findOne({now_playing: true}, {sort: [["created_at", "asc"]]})
#   PlaylistTracks.findOne {now_playing: true},
#     sort: [["created_at", "asc"]]

# window.markAsNowPlaying = (track) ->
#   # PlaylistTracks.update(track._id, {$set: {now_playing: true}})
#   PlaylistTracks.update track._id,
#     $set:
#       now_playing: true

# window.addToPlaylist = (track_id) ->
#   SC.get "/tracks/#{track_id}", (track, error) ->
#     if error
#       Meteor.Error(404, error.message)
#     else
#       PlaylistTracks.insert
#         track_id: track.id
#         title:    track.title
#         username: if track.user then track.user.username else "Unknown"
#         duration: track.duration
#         artwork_url: track.artwork_url
#         permalink_url: track.permalink_url
#         position: 0
#         now_playing: false
#         added_by: Meteor.user()
#         upVotes: []
#         downVotes: []
#         created_at: new Date()

# window.removeFromPlaylist = (track_id) ->
#   PlaylistTracks.remove track_id

# window.favourite = (track_id) ->
#   SC.put "/me/favorites/#{track_id}", (response) ->
#     console.log response
#     favourites = Session.get 'sc.favorites'
#     newFavs = arrayUnique(favourites.concat([parseInt(track_id)]))
#     Session.set 'sc.favorites', newFavs

# window.unFavourite = (track_id) ->
#   SC.delete "/me/favorites/#{track_id}", (response) ->
#     favourites = Session.get 'sc.favorites'
#     newFavs = arrayUnique(_.without(favourites, parseInt(track_id)))
#     Session.set 'sc.favorites', newFavs

# window.getFavorites = (offset = 0, limit = 200) ->
#   offset = offset
#   limit = limit
#   favorites = Session.get 'sc.favorites'

#   unless favorites
#     Session.set 'sc.favorites', null
  
#   SC.get "/me/favorites", {offset: offset, limit: limit}, (response, error) ->
#     # Error?
#     if error
#       return

#     # array of id's
#     # [1,2,3,4] etc
#     favorites = Session.get 'sc.favorites'
#     favorites = if favorites == null then [] else favorites
#     response.forEach (track) ->
#       favorites.push track.id

#     Session.set 'sc.favorites', arrayUnique(favorites)

#     if response.length > 0
#       offset = offset + limit
#       getFavorites offset

# window.arrayUnique = (array) ->
#   a = array.concat()
#   i = 0

#   while i < a.length
#     j = i + 1

#     while j < a.length
#       a.splice j--, 1  if a[i] is a[j]
#       ++j
#     ++i
#   a

# window.inFavorites = (track_id) ->
#   favorites = Session.get('sc.favorites')
#   if favorites
#     return _.find Session.get('sc.favorites'), (track) ->
#       if track.id == track_id
#         return track

# window.accessToken = ->
#   return Meteor.user().services.soundcloud.accessToken

# window.search = (search_query) ->
#   page_size = 20
#   SC.get "/tracks", 
#     q: search_query,
#     filter: "streamable, public",
#     limit: page_size, (tracks) ->
#       Session.set("search_results", tracks)

# window.clearSearch = ->
#   Session.set("search_results", null)  

# window.track_length = (duration) ->
#   seconds = parseInt((duration/1000)%60)
#   minutes = parseInt((duration/(1000*60))%60)
#   hours   = parseInt((duration/(1000*60*60))%24)

#   hours   = if hours < 10 then "0" + hours else hours
#   minutes = if minutes < 10 then "0" + minutes else minutes
#   seconds = if seconds < 10 then "0" + seconds else seconds
  
#   duration_string = ""
#   duration_string += "#{hours}:" unless hours == "00"
#   duration_string += "#{minutes}:#{seconds}"

#   return duration_string
