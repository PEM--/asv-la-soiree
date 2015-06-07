# Main application controller
class @AppCtrl extends RouteController
  layoutTemplate = 'mainLayout'
  loadingTemplate = 'loading'
  onRun: -> appLog.warn 'AppCtrl: onRun', @
  onRerun: ->
    appLog.warn 'AppCtrl: onReRun', @
    @$mainCntEl = $ Router.mainCntEl
    @$routerEl = @$mainCntEl.find Router.routerEl
    @next()
  onBeforeAction: ->
    appLog.warn 'AppCtrl: onBeforeAction'
    # Render nav and footer before letting children controller do their
    #  won actions
    @render 'nav', {to: 'nav'}
    @render 'footer', {to: 'footer'}
    @next()
  onAfterAction: ->
    appLog.warn 'AppCtrl: onAfterAction'
  onStop: ->
    appLog.warn 'AppCtrl: onStop'
    mainMenuModel.menuContentOpened false
  waitOn: -> [
    Meteor.subscribe 'innerlinks'
    Meteor.subscribe 'basicpages'
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
    Meteor.subscribe 'basicpages', =>
      Router.declareRoutes()
      @start()

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
  Meteor.subscribe 'basicpages', ->
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
