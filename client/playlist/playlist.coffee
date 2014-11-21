Template.playlist.events 
  "click a.remove": (event) ->
    event.preventDefault()
    player.removeFromPlaylist event.currentTarget.dataset.trackId
    return

  "click a.favorite": (event) ->
    event.preventDefault()
    track_id = event.currentTarget.dataset.trackId
    player.favourite track_id
    return

  "click a.favorited": (event) ->
    event.preventDefault()
    track_id = event.currentTarget.dataset.trackId
    player.unFavourite track_id
    return

Template.playlist.helpers
  tracks: ->
    return PlaylistTracks.find {now_playing: false}, 
      sort: [["created_at", "asc"]]

  length: (duration) ->
    return player.track_length(duration)

  allowedToRemove: ->
    return @added_by._id == Meteor.user()._id

  avatar_url: ->
    return @added_by.services.soundcloud.avatar_url

  favourited: ->
    accessTokenDep.depend()

    favorites = Session.get 'sc.favorites'
    track = $.inArray @track_id, favorites

    return if track > -1 then "favorited" else "favorite"