if Meteor.isClient
  Template.notFound.onRendered ->
    appLog.info 'Not found template', window.location
    mainMenuModel.show()
  Template.notFound.events 'click .not-found': -> goNextRoute '/'
