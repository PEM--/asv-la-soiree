if Meteor.isClient
  Meteor.startup ->
    sAlert.config effect: 'jelly'
