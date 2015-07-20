if Meteor.isClient

  class @CookieSingleton
    instance = null
    @get: ->
      instance ?= new CookieInner
    class CookieInner
      COOKIE_NAME = 'AsvLaSoiree'
      COOKIE_EXPIRATION = 6*31
      # User has already accepted the cookie
      isAccepted: ->
        cookie = Cookies.getJSON COOKIE_NAME
        appLog.info 'Current cookie acceptation status', cookie
        return false if cookie is undefined
        return true
      # User accept the cookie
      accept: ->
        appLog.info 'Setting cookie to accepted'
        cookie = Cookies.getJSON COOKIE_NAME
        if cookie is undefined
          cookie = accepted: true
        else
          cookie.accepted = true
        Cookies.set COOKIE_NAME, cookie, COOKIE_EXPIRATION
      # User has already presubscribed
      isPreSubed: ->
        # Without cookie approuval, user can't have perform presubscription
        return false unless @isAccepted()
        cookie = Cookies.getJSON COOKIE_NAME
        return cookie.preSubscriptionValue?
      # User has validated his payment
      isPaymentUserValidated: ->
        # Without subsciption, user can't have validated the payemnt form.
        return false unless @isPreSubed()
        cookie = Cookies.getJSON COOKIE_NAME
        return cookie.preSubscriptionValue.paymentUserValidated?
      # Simple accessor to all cookie content
      content: -> Cookies.getJSON COOKIE_NAME
      # User has done a valid presubscription
      preSubStore: (obj) ->
        appLog.info 'Store user\'s pre-subscription', obj
        # Ensure cookie is defined
        @accept()
        # Store its value and its presubscription date
        cookie = Cookies.getJSON COOKIE_NAME
        cookie.preSubscriptionValue = obj
        cookie.preSubscriptionDate = new Date
        Cookies.set COOKIE_NAME, cookie, COOKIE_EXPIRATION
      # User has already done a contact request
      isContacted: ->
        return false unless @isAccepted()
        cookie = Cookies.getJSON COOKIE_NAME
        return cookie.contactRequestDate?
      # User has done a valid contact request
      askContact: (obj) ->
        appLog.info 'Store user\'s contact request', obj
        # Ensure cookie is defined
        @accept()
        # Store its value and its contact date
        cookie = Cookies.getJSON COOKIE_NAME
        cookie.contactRequest = obj
        cookie.contactRequestDate = new Date
        Cookies.set COOKIE_NAME, cookie, COOKIE_EXPIRATION

  Template.cookie.onCreated ->
    appLog.info 'Cookie template created'

  Template.cookie.onRendered ->
    unless CookieSingleton.get().isAccepted()
      Meteor.setTimeout =>
        effect = if IS_MOBILE then 'transition.fadeIn' \
          else 'transition.bounceDownIn'
        @$('.cookie').velocity effect
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
      effect = if IS_MOBILE then 'transition.fadeOut' \
        else 'transition.bounceUpOut'
      t.$('.cookie').velocity effect
      # Remove all cookie masks
      $masks = $ '.cookieMask'
      $masks.velocity 'transition.fadeOut', -> $masks.remove()
