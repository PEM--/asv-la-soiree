if Meteor.isClient
  Template.contact.viewmodel
    isCookieAccepted: -> CookieSingleton.get().isAccepted()
