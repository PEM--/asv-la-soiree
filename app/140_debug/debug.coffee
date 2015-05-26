if Meteor.isClient
  Template.debug.onCreated ->
    Session.set 'debug', 'nothing'
