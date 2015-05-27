if Meteor.isClient
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

  Meteor.startup ->
    Router.configure
      layoutTemplate: 'mainLayout'
      loadingTemplate: 'loading'
      notFoundTemplate: 'notFound'
      waitOn: -> [
        Meteor.subscribe 'pages'
      ]

    # Set static routes
    Router.route '/', ->
      @render 'nav', to: 'nav', data: -> Pages.find()
      @render 'home', data: -> Pages.find()
      @render 'footer', to: 'footer', data: -> Pages.find()
    # Set dynamic routes depending on pages created in Orion
    Pages.find().observeChanges
      added: (id, fields) ->
        appLog.info 'Route added', fields.slug, fields.title
        Router.route fields.slug, ->
          @render 'nav', to: 'nav', data: -> Pages.find()
          @render 'basicPage', data: -> Pages.findOne id
          @render 'footer', to: 'footer', data: -> Pages.find()
