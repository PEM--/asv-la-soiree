if Meteor.isClient

  class @CookieSingleton
    instance = null
    @get: ->
      instance ?= new CookieInner
    class CookieInner
      cookieName = 'AsvLaSoiree'
      expiration = 6*31
      # User has already accepted the cookie
      isAccepted: ->
        cookie = Cookies.getJSON cookieName
        appLog.info 'Current cookie acceptation status', cookie
        return false if cookie is undefined
        return true
      # User accept the cookie
      accept: ->
        appLog.info 'Setting cookie to accepted'
        cookie = Cookies.getJSON cookieName
        if cookie is undefined
          cookie = accepted: true
        else
          cookie.accepted = true
        Cookies.set cookieName, cookie, expiration
      # User has already presubscribed
      isPreSubed: ->
        # Without cookie approuval, user can't have perform presubscription
        return false unless @isAccepted()
        cookie = Cookies.getJSON cookieName
        return cookie.preSubscriptionValue?
      # User has done a valid presubscription
      preSubStore: (obj) ->
        appLog.info 'Store user\'s pre-subscription', obj
        # Ensure cookie is defined
        @accept()
        # Store its value and its presubscription date
        cookie = Cookies.getJSON cookieName
        cookie.preSubscriptionValue = obj
        cookie.preSubscriptionDate = new Date
        Cookies.set cookieName, cookie, expiration
      # User has already done a contact request
      isContacted: ->
        return false unless @isAccepted()
        cookie = Cookies.getJSON cookieName
        return cookie.contactRequestDate?
      # User has done a valid contact request
      askContact: (obj) ->
        appLog.info 'Store user\'s contact request', obj
        # Ensure cookie is defined
        @accept()
        # Store its value and its contact date
        cookie = Cookies.getJSON cookieName
        cookie.contactRequest = obj
        cookie.contactRequestDate = new Date
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
      Router.go e.target.href
    'click button': (e, t) ->
      CookieSingleton.get().accept()
      # Remove cookie notification
      t.$('.cookie').velocity 'transition.bounceUpOut'
      # Remove all cookie masks
      $masks = ($ '.cookieMask')
      $masks.velocity 'transition.fadeOut', -> $masks.remove()
