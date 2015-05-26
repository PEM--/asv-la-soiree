if Meteor.isClient
  @mainMenuModel = new ViewModel
    white: false
    menuContentOpened: false
    opacity: 1
    show: ->  @opacity 1
    hide: -> @opacity 0
    height: ->
      # TODO Fix this hideous hack
      if @templateInstance is undefined then 52 \
      else (@templateInstance.$ 'nav').height()
    goHome: ->
      @menuContentOpened false
      goNextRoute '/'
    hamburger: (e) -> @menuContentOpened not @menuContentOpened()
    changeRoute: (e) ->
      e.preventDefault()
      @menuContentOpened false
      goNextRoute e.target.pathname
    links: []
    blaze_helpers: ->
      # These elements are stored in a regular Blaze helpers as they
      #  are using global values that ViewModel doesn't handle.
      # @TODO Set these in a regular ViewModel
      activeRoute: ->
        curSlug = getSlug()
        if @slug is curSlug then 'active' else ''

  Template.nav.onRendered -> mainMenuModel.bind @
