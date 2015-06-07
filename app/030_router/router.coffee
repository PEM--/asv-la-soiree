# Main application controller
class AppCtrl extends RouteController
  layoutTemplate = 'mainLayout'
  loadingTemplate = 'loading'
  onBeforeAction: ->
    @render 'nav', {to: 'nav'}
    @render 'footer', {to: 'footer'}
    @next()
  waitOn: -> [
    Meteor.subscribe 'innerlinks'
    Meteor.subscribe 'basicpages'
  ]

# Common server and client config
globalConfig =
  layoutTemplate: 'mainLayout'
  loadingTemplate: 'loading'
  fastRender: true
  controller: AppCtrl
Router.plugin 'dataNotFound', notFoundTemplate: 'notFound'
Router.plugin 'loading', loadingTemplate: 'loading'
# Specific server configuration
if Meteor.isServer
  Router.configure _.extend globalConfig, autoRender: false
# Specific client configuration
if Meteor.isClient
  Router.configure _.extend globalConfig, autoStart: false

# Set of additional methods on the router
Router.declareRoutes = ->
  pages = BasicPages.find().fetch()
  # Creating dynamic routes
  for page in pages
    do (page=page) =>
      appLog.info 'Adding page', page.slug
      @route page.slug, -> @render 'basicPage', data: -> page
  # Creating static routes
  appLog.info 'Adding home page'
  @route '/', action: -> @render 'home'
  appLog.info 'Adding not found route'
  @route '/:not_found', action: -> @render 'notFound'
# Specific methods and values for the client
if Meteor.isClient
  Router.mainCntEl = '.main-container[data-role=\'layout\']'
  Router.routerEl = "#{Router.mainCntEl}>.router-container"
  Router.declareClientRoutes = ->
    Meteor.subscribe 'basicpages', =>
      Router.declareRoutes()
      @start()
  # Get only the slug from an URL
  Router.slugIt = (url) ->
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
  Router.getSlug = ->
    curUrl = Router.current()?.url
    return unless curUrl?
    Router.slugIt curUrl
  # Global router function ensuring transition with fadeIn before the
  # the template rendering is done and a fadeOut when the template
  # is rendered.
  Router.goNextRoute = (nextRoute) ->
    # Check if provided route is an inner links
    if nextRoute.startsWith '#'
      # If we are already on the landing page, just scroll to the inner link
      if Router.getSlug() is '/'
        ($ "[href='#{nextRoute}']").velocity('scroll', {container: $ Router.mainCntEl})
        return
      # If we are not on the landing page, transition to it and set an
      # automatic scroll after page transitions
      else
        innerLink = nextRoute
        nextRoute = '/'
        Meteor.setTimeout ->
          ($ "[href='#{innerLink}']").velocity('scroll', {container: $ Router.mainCntEl})
        , 600
    nextRoute = Router.slugIt nextRoute
    if nextRoute is Router.getSlug()
      ($ Router.routerEl).velocity('scroll', {container: $ Router.mainCntEl})
      return
    ($ Router.routerEl).css 'opacity', 0
    # Transition when fade out animation is done
    Meteor.setTimeout =>
      appLog.info 'Going slug', nextRoute
      mainMenuModel.reset()
      unless nextRoute is '/'
        Waypoint.destroyAll()
        ScrollerSingleton.get().stop()
        mainMenuModel.show()
      # Reset current scroll position
      ($ Router.mainCntEl).scrollTop 0
      # Activate route
      Router.go nextRoute
      # Fade in the new content with at least 2 cycles on the RAF
      Meteor.setTimeout (=> ($ Router.routerEl).css 'opacity', 1), 64
    , 300

# Start the router
Meteor.startup ->
  # Add routes for the server
  if Meteor.isServer
    Router.declareRoutes()
  # Add routes for the client and start the routing
  if Meteor.isClient
    Router.declareClientRoutes()
    appLog.info 'Router started'

  # Set dynamic routes depending on pages created in Orion
  # appLog.info 'Starting subscription and routing'
  Meteor.subscribe 'basicpages', ->
    BasicPages.find().observeChanges
      added: (id, fields) ->
        if Router.routes[fields.slug] is undefined
          appLog.info 'Route added', fields.slug
          Router.route fields.slug, -> @render 'basicPage',
            data: ->
              slug: fields.slug
              title: fields.title
              body: fields.body
        else
          appLog.info 'Route already exists', fields.slug
