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

Template.now_playing.helpers
  now_playing: ->
    return player.nowPlaying()

  length: ->
    return player.track_length @duration

  elapsed: ->
    return Session.get "local_elapsed_time"

  avatar_url: ->
    return @added_by.services.soundcloud.avatar_url

  favourited: ->
    accessTokenDep.depend()

    favorites = Session.get 'sc.favorites'
    track = $.inArray @track_id, favorites

    return if track > -1 then "favorited" else "favorite"

  total_upVotes: ->
    return @upVotes.length

  total_downVotes: ->
    return @downVotes.length