Template.playlist.events 
  "click a.remove": (event) ->
    event.preventDefault()
    removeFromPlaylist event.currentTarget.dataset.trackId
    return

  "click a.favorite": (event) ->
    event.preventDefault()
    track_id = event.currentTarget.dataset.trackId
    favourite track_id
    return

  "click a.favorited": (event) ->
    event.preventDefault()
    track_id = event.currentTarget.dataset.trackId
    unFavourite track_id
    return

Template.playlist.tracks = ->
  return PlaylistTracks.find {now_playing: false}, 
    sort: [["created_at", "asc"]]

Template.playlist.length = (duration) ->
  return track_length(duration)

Template.playlist.allowedToRemove = ->
  return @added_by._id == Meteor.user()._id

Template.playlist.avatar_url = ->
  return @added_by.services.soundcloud.avatar_url

Template.playlist.favourited = ->
  accessTokenDep.depend()

  favorites = Session.get 'sc.favorites'
  track = $.inArray @track_id, favorites

  return if track > -1 then "favorited" else "favorite"