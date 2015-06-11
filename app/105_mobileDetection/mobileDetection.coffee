if Meteor.isClient
  # Global variable determined at Meteor's start
  window.IS_MOBILE = 'ontouchstart' of window
  #window.IS_MOBILE = true
