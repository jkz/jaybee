Meteor.publish 'SC.OAuth', () ->
  return Meteor.users.find Meteor.userId, 
    fields: 
      'services.soundcloud': 1