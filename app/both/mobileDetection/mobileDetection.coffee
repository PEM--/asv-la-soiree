if Meteor.isClient
  # Global variable determined at Meteor's start
  Session.set 'IS_MOBILE', 'ontouchstart' of window
  #Session.set 'IS_MOBILE', true
