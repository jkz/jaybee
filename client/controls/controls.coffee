Template.controls.events 
  "click [data-control=play]": (event) ->
    event.preventDefault()

    track = nowPlaying()
    if track
      play track._id
    else
      playNext()
    return

  "click [data-control=next]": (event) ->
    event.preventDefault()
    playNext()
    return