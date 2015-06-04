if Meteor.isClient

  class @CookieSingleton
    instance = null
    @get: ->
      instance ?= new CookieInner
    class CookieInner
      cookieName = 'AsvLaSoiree'
      expiration = 6*31
      isAccepted: ->
        cookie = Cookies.getJSON cookieName
        appLog.info 'Current cookie acceptation status', cookie
        return false if cookie is undefined
        return true
      accept: ->
        appLog.info 'Setting cookie to accepted'
        cookie = Cookies.getJSON cookieName
        if cookie is undefined
          cookie = accepted: true
        else
          cookie.accepted = true
        Cookies.set cookieName, cookie, expiration

  Template.cookie.onCreated ->
    appLog.info 'Cookie template created'

  Template.cookie.onRendered ->
    unless CookieSingleton.get().isAccepted()
      Meteor.setTimeout =>
        @$('.cookie').velocity 'transition.bounceDownIn'
      , 600

  Template.cookie.helpers
    isCookieAccepted: -> CookieSingleton.get().isAccepted()

  Template.cookie.events
    'click a': (e, t) ->
      e.preventDefault()
      goNextRoute e.target.href
    'click button': (e, t) ->
      CookieSingleton.get().accept()
      # Remove cookie notification
      t.$('.cookie').velocity 'transition.bounceUpOut'
      # Remove all cookie masks
      $masks = ($ '.cookieMask')
      $masks.velocity 'transition.fadeOut', -> $masks.remove()
