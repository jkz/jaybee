# Listeners
Template.listeners.helpers
  listeners: ->
    return Meteor.users.find({ "profile.online": true }).fetch()