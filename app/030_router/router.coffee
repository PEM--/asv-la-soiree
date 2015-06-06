class @AppCtrl extends RouteController
  layoutTemplate = 'mainLayout'
  loadingTemplate = 'loading'
  onBeforeAction: ->
    @next()
  waitOn: -> [
    Meteor.subscribe 'innerlinks'
    Meteor.subscribe 'basicpages'
  ]

# Configure router
Meteor.startup ->
  Router.plugin 'dataNotFound', notFoundTemplate: 'notFound'
  Router.plugin 'loading', loadingTemplate: 'loading'
  Router.declareRoutes = ->
    pages = BasicPages.find().fetch()
    # Creating dynamic routes
    for page in pages
      do (page=page, pages=pages) =>
        appLog.info 'Adding page', page.slug
        @route page.slug,
          data: -> pages
          action: ->
            @render 'nav', {to: 'nav'}
            @render 'basicPage', data: -> page
            @render 'footer', {to: 'footer'}
    # Creating static routes
    appLog.info 'Adding home page'
    @route '/',
      data: -> pages
      action: ->
        @render 'nav', {to: 'nav'}
        @render 'home'
        @render 'footer', {to: 'footer'}
  # Common server and client config
  globalConfig =
    layoutTemplate: 'mainLayout'
    loadingTemplate: 'loading'
    fastRender: true
    controller: AppCtrl
  # Specific router behavior on the server
  if Meteor.isServer
    Router.configure _.extend globalConfig, autoRender: false
    Router.declareRoutes()
  # Specific router behavior on the client
  if Meteor.isClient
    Router.declareClientRoutes = ->
      Meteor.subscribe 'basicpages', =>
        @declareRoutes()
        @start()
    Router.configure _.extend globalConfig, autoStart: false
    Router.declareClientRoutes()

    # Get only the slug from an URL
    @slugIt = (url) ->
      tokens = url.split '/'
      while tokens.length isnt 0
        token = tokens.shift()
        if (token.search document.domain) isnt -1
          break
      # Provided URL was a real slug
      return url if tokens.length is 0
      # Provided URL was a full URI
      '/' + tokens.join '/'
    # Global router function ensuring to get the current slug.
    # When reloading a page or getting a direct acces, the reactive
    # value Router.current().url provides the full URL but when
    # activated inside the client app, it returns the slug.
    # This function ensure that only the slug is returned.
    @getSlug = ->
      curUrl = Router.current()?.url
      return unless curUrl?
      @slugIt curUrl

    # Global router function ensuring transition with fadeIn before the
    # the template rendering is done and a fadeOut when the template
    # is rendered.
    @goNextRoute = (nextRoute) ->
      # Check if provided route is an inner links
      if nextRoute.startsWith '#'
        # If we are already on the landing page, just scroll to the inner link
        if @getSlug() is '/'
          ($ "[href='#{nextRoute}']").velocity('scroll', {container: $ mainCntEl})
          return
        # If we are not on the landing page, transition to it and set an
        # automatic scroll after page transitions
        else
          innerLink = nextRoute
          nextRoute = '/'
          Meteor.setTimeout ->
            ($ "[href='#{innerLink}']").velocity('scroll', {container: $ mainCntEl})
          , 600
      nextRoute = slugIt nextRoute
      if nextRoute is getSlug()
        ($ routerEl).velocity('scroll', {container: $ mainCntEl})
        return
      ($ routerEl).css 'opacity', 0
      # Transition when fade out animation is done
      Meteor.setTimeout ->
        appLog.info 'Going slug', nextRoute
        mainMenuModel.reset()
        unless nextRoute is '/'
          Waypoint.destroyAll()
          ScrollerSingleton.get().stop()
          mainMenuModel.show()
        # Reset current scroll position
        ($ mainCntEl).scrollTop 0
        # Activate route
        Router.go nextRoute
        # Fade in the new content with at least 2 cycles on the RAF
        Meteor.setTimeout (-> ($ routerEl).css 'opacity', 1), 64
      , 300

# @TODO Set in the Router client side
@mainCntEl = '.main-container[data-role=\'layout\']'
@routerEl = "#{mainCntEl}>.router-container"

# Set dynamic routes depending on pages created in Orion
# @TODO Need big rework
# appLog.info 'Starting subscription and routing'
# Meteor.subscribe 'basicpages', ->
#   BasicPages.find().observeChanges
#     added: (id, fields) ->
#       if Router.routes[fields.slug] is undefined
#         appLog.info 'Route added', fields.slug, fields.title
#         Router.route fields.slug, ->
#           @render 'nav', to: 'nav', data: ->
#             BasicPages.find {$or: [{display: 1}, {display: 2}]}, sort: order: 1
#           @render 'basicPage', data: -> BasicPages.findOne id
#           @render 'footer', to: 'footer', data: ->
#             BasicPages.find {$or: [{display: 2}, {display: 3}]}, sort: order: 1
#       else
#         appLog.info 'Route already exists', fields.slug
