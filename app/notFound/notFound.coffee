if Meteor.isClient
  Template.notFound.events 'click .not-found': -> Router.go '/'
