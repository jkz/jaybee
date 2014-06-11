# Listeners
  Template.listeners.listeners = ->
    return Meteor.users.find({ "profile.online": true }).fetch()