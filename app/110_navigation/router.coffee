if Meteor.isClient
  Router.configure
    layoutTemplate: 'mainLayout'
    loadingTemplate: 'loading'
    notFoundTemplate: 'notFound'

  # Global router function ensuring to get the current slug.
  # When reloading a page or getting a direct acces, the reactive
  # value Router.current().url provides the full URL but when
  # activated inside the client app, it returns the slug.
  # This function ensure that only the slug is returned.
  @getSlug = ->
    curUrl = Router.current()?.url
    return unless curUrl?
    # Remove hash
    curUrl = (curUrl.split '#')[0]
    # Check if current URL contains hostname
    count = curUrl.search __meteor_runtime_config__.ROOT_URL
    return curUrl if count is -1
    curUrl.substr __meteor_runtime_config__.ROOT_URL.length - 1

  # Global router function ensuring transition with fadeIn before the
  # the template rendering is done and a fadeOut when the template
  # is rendered.
  @goNextRoute = (nextRoute) ->
    ($ routerEl).css 'opacity', 0
    # Transition when fade out animation is done
    Meteor.setTimeout ->
      # Reset current scroll position
      ($ mainCntEl).scrollTop 0
      # Activate route
      Router.go nextRoute
      # Fade in the new content with at least 2 cycles on the RAF
      Meteor.setTimeout ->
        ($ routerEl).css 'opacity', 1
      , 64
    , 300

  @navLinks = []

  Meteor.startup ->
    # Set static routes
    Router.route '/', name: 'home'
    # Set dynamic routes depending on pages created in Orion
    pageHandler = Meteor.subscribe 'pages'
    #Pages.find().observe

    Tracker.autorun (computation) ->
      appLog.info 'New pages'
      unless pageHandler.ready()
        return appLog.warn 'Waiting to pages subscription'
      pages = Pages.find()
      currentPages = mainMenuModel.links()
      console.log 'Current pages', currentPages
      for page in pages
        # Only insert page that are not already added
        unless page in currentPages
          Router.route page.slug
          mainMenuModel.links().push slug: page.slug, name: page.title



    Tracker.autorun (computation) ->
      curSlug = getSlug()
      unless computation.firstRun
        # Only the opacity to 1 on slug route except home
        # @NOTE This fixes a bug on Safari iOS and Chrome Android
        t = _.pluck navLinks, 'slug'
        if curSlug in _.pluck navLinks, 'slug'
          ViewModel.byId('mainMenu').show()
          Waypoint.destroyAll()
