Template.controls.events 
  "click [data-control=play]": (event) ->
    event.preventDefault()
    track = player.nowPlaying()
    if track
      player.play(track._id)
    else
      player.playNext()
    return

  "click [data-control=next]": (event) ->
    event.preventDefault()
    player.playNext()
    return