if Meteor.isClient
  # Model for the main menu
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
    # @TODO Get only the relevant page that are set for the menu or
    # menu and footer
    links: -> Pages.find {}, sort: order: 1

    # blaze_helpers: ->
    #   # These elements are stored in a regular Blaze helpers as they
    #   #  are using global values that ViewModel doesn't handle.
    #   # @TODO Set these in a regular ViewModel
    #   activeRoute: ->
    #     curSlug = getSlug()
    #     if @slug is curSlug then 'active' else ''

  # Subscribe to pages
  Template.nav.onCreated ->
    # Template level subscription for Pages used in the navigation links
    @subscribe 'pages'
    # Expose its properties for Blaze
    @vm = mainMenuModel
    @vm.addHelper 'links', @

  Template.nav.onRendered ->
    # Bind ViewModel to template
    mainMenuModel.bind @

  # ViewModel for the menu's items
  Template.navItem.viewmodel (data) ->
    id: data._id
    page: -> Pages.findOne @id()
    slug: -> @page().slug
    name: -> @page().title
    changeRoute: (e) ->
      e.preventDefault()
      @parent().menuContentOpened false
      goNextRoute @slug()
