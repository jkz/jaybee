Meteor.methods
  addToPlaylist: (track) ->
    check(track, Object)

    PlaylistTracks.insert
      track_id: track.id
      title:    track.title
      username: if track.user then track.user.username else "Unknown"
      duration: track.duration
      artwork_url: track.artwork_url
      permalink_url: track.permalink_url
      position: 0
      now_playing: false
      added_by: Meteor.user()
      upVotes: []
      downVotes: []
      created_at: new Date()

  removeFromPlaylist: (track_id) ->
    PlaylistTracks.remove track_id

  markAsNowPlaying: (track) ->
    # PlaylistTracks.update(track._id, {$set: {now_playing: true}})
    PlaylistTracks.update track._id,
      $set:
        now_playing: true

  nowPlaying: ->
    # PlaylistTracks.findOne({now_playing: true}, {sort: [["created_at", "asc"]]})
    return PlaylistTracks.findOne {now_playing: true},
      sort: [["created_at", "asc"]]

  nextTrack: ->
    # PlaylistTracks.findOne({now_playing: false}, {sort: [["created_at", "asc"]]})
    return PlaylistTracks.findOne {now_playing: false}, 
      sort: [["created_at", "asc"]]