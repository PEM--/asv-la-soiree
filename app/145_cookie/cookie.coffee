if Meteor.isClient
  isCookieAccepted = ->
    cookie = Cookies.getJSON 'AsvLaSoiree'
    appLog.info 'Current cookie acceptation status', cookie
    return false if cookie is undefined
    return true

  Template.cookie.onCreated ->
    appLog.info 'Cookie template created'

  Template.cookie.onRendered ->
    if isCookieAccepted
      Meteor.setTimeout =>
        @$('.cookie').velocity 'transition.bounceDownIn'
      , 600

  Template.cookie.helpers
    isCookieAccepted: -> isCookieAccepted()

  Template.cookie.events
    'click a': (e, t) ->
      e.preventDefault()
      goNextRoute e.target.href
    'click button': (e, t) ->
      appLog.info 'Setting cookie to accepted'
      cookie = Cookies.getJSON 'AsvLaSoiree'
      if cookie is undefined
        cookie = accepted: true
      else
        cookie.accepted = true
      Cookies.set 'AsvLaSoiree', cookie, expire: 6*31
      # Remove cookie notification
      t.$('.cookie').velocity 'transition.bounceUpOut'
