# Main application controller
class @AppCtrl extends RouteController
  layoutTemplate = 'mainLayout'
  loadingTemplate = 'loading'
  onRerun: ->
    @$mainCntEl = $ Router.mainCntEl
    @$routerEl = @$mainCntEl.find Router.routerEl
    @next()
  onBeforeAction: ->
    # Render nav and footer before letting children controller do their
    #  won actions
    @render 'nav', {to: 'nav'}
    @render 'footer', {to: 'footer'}
    @next()
  onStop: ->
    mainMenuModel.menuContentOpened false
  waitOn: -> [
    globalSubs.subscribe 'innerlinks'
    globalSubs.subscribe 'basicpages'
  ]

# Common server and client config
globalConfig =
  layoutTemplate: 'mainLayout'
  loadingTemplate: 'loading'
  fastRender: true
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
      @route page.slug, controller: BasicPageController, action: ->
        @render 'basicPage', data: -> page
  # Creating static routes
  appLog.info 'Adding not found route'
  @route '/:not_found', controller: AppCtrl, action: -> @render 'notFound'
# Specific methods and values for the client
if Meteor.isClient
  Router.mainCntEl = '.main-container[data-role=\'layout\']'
  Router.routerEl = '>.router-container'
  Router.declareClientRoutes = ->
    globalSubs.subscribe 'basicpages', =>
      Router.declareRoutes()
      @start()
  Router.oldGo = Router.go
  Router.go = ->
    # Classic Router.go function
    Router.oldGo arguments[0], arguments[1]
    # Handle fragment URL if provided
    unless (arguments[0].search '#') is -1
      Meteor.setTimeout ->
        HomeController.scrollToFragment()
      , 300
    # Handle scroll to top
    if s.endsWith arguments[0], '/'
      Meteor.setTimeout ->
        HomeController.scrollToTop()
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
  appLog.info 'Starting subscription and routing'
  globalSubs.subscribe 'basicpages', ->
    BasicPages.find().observeChanges
      added: (id, fields) ->
        if Router.routes[fields.slug] is undefined
          appLog.info 'Route added', fields.slug
          Router.route fields.slug, controller: BasicPageController, action: ->
            @render 'basicPage', data: ->
              slug: fields.slug
              title: fields.title
              body: fields.body
        else
          appLog.info 'Route already exists', fields.slug
