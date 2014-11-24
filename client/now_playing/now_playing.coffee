Template.now_playing.events
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

  "click [data-control=upvote]": (event) ->
    event.preventDefault()
    console.log "upvote click"
    Meteor.call "upVote"

  "click [data-control=downvote]": (event) ->
    event.preventDefault()
    console.log "downVote click"
    Meteor.call "downVote"

Template.now_playing.helpers
  now_playing: ->
    return Session.get "now_playing"

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
    console.log "Upvotes: ", @upVotes.length
    return @upVotes.length

  total_downVotes: ->
    console.log "DownVotes: ", @downVotes.length
    return @downVotes.length