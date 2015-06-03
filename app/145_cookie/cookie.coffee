if Meteor.isClient
  Template.cookie.onCreated ->
    appLog.info 'Cookie template created'

  Template.cookie.events
    'click a': (e, t) ->
      e.preventDefault()
      appLog.info 'Cookie', e
    'click button': (e, t) ->
      appLog.info 'Pouet'
