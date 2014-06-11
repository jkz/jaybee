Template.now_playing.events
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

  "click [data-control=upvote]": (event) ->
    event.preventDefault()
    upVote()
    return

  "click [data-control=downvote]": (event) ->
    event.preventDefault()
    downVote()
    return

Template.now_playing.now_playing = ->
  return nowPlaying()

Template.now_playing.length = ->
  return track_length @duration

Template.now_playing.elapsed = ->
  return Session.get "local_elapsed_time"

Template.now_playing.avatar_url = ->
  return @added_by.services.soundcloud.avatar_url

Template.now_playing.favourited = ->
  accessTokenDep.depend()

  favorites = Session.get 'sc.favorites'
  track = $.inArray @track_id, favorites

  return if track > -1 then "favorited" else "favorite"

Template.now_playing.total_upVotes = ->
  return @upVotes.length

Template.now_playing.total_downVotes = ->
  return @downVotes.length