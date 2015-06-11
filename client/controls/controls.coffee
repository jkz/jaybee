Template.controls.events 
  "click [data-control=play]": (event) ->
    event.preventDefault()
    Meteor.call "nowPlaying", (error, track) ->
      if track
        player.play track
      else
        player.playNext()

  "click [data-control=next]": (event) ->
    event.preventDefault()
    player.playNext()