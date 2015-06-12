Template.controls.events
  "click [data-control=play]": (event) ->
    event.preventDefault()
    Meteor.call "nowPlaying", (error, track) ->
      if track
        player.play track._id
      else
        player.playNext()

  "click [data-control=next]": (event) ->
    event.preventDefault()
    player.playNext()

  "click [data-control=volume-up]": (event) ->
    event.preventDefault()
    Meteor.call "changeVolume", 10

  "click [data-control=volume-down]": (event) ->
    event.preventDefault()
    Meteor.call "changeVolume", -10
