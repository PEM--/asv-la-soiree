if Meteor.isClient
  @mainCntEl = '.main-container[data-role=\'layout\']'
  @routerEl = "#{mainCntEl}>.router-container"
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

  # Set dynamic routes depending on pages created in Orion
  appLog.info 'Starting subscription and routing'
  Meteor.subscribe 'pages', ->
    Pages.find().observeChanges
      added: (id, fields) ->
        if Router.routes[fields.slug] is undefined
          appLog.info 'Route added', fields.slug, fields.title
          Router.route fields.slug, ->
            @render 'nav', to: 'nav', data: ->
              Pages.find {$or: [{display: 1}, {display: 2}]}, sort: order: 1
            @render 'basicPage', data: -> Pages.findOne id
            @render 'footer', to: 'footer', data: ->
              Pages.find {$or: [{display: 2}, {display: 3}]}, sort: order: 1
        else
          appLog.info 'Route already exists', fields.slug
