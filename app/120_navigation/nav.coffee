if Meteor.isClient
  # Model for the main menu
  @mainMenuModel = new ViewModel
    white: false
    menuContentOpened: false
    opacity: 0
    show: ->  @opacity 1
    hide: -> @opacity 0
    height: 52
    goHome: ->
      @menuContentOpened false
      Router.go '/'
    hamburger: (e) -> @menuContentOpened not @menuContentOpened()
    innerLinks: -> InnerLinks.find {}, sort: order: 1
    # @NOTE The pages are requested again for taking use of a reative cursor
    links: ->
      BasicPages.find {$or: [{display: 1}, {display: 2}]}, sort: order: 1

  Template.nav.onCreated ->
    appLog.info 'Creating main menu'
    # Expose the ViewModel's helpers to Blaze
    @vm = mainMenuModel
    @vm.addHelpers ['links', 'innerLinks'], @

  Template.nav.onRendered ->
    appLog.info 'Rendering main menu'
    # Bind ViewModel to template
    mainMenuModel.bind @

  # ViewModel for the menu's items on inner links (links under the home page)
  Template.navInnerLink.viewmodel (data) ->
    id: data._id
    page: -> InnerLinks.findOne @id()
    slug: -> @page().slug
    name: -> @page().title
    changeRoute: (e) ->
      e.preventDefault()
      mainMenuModel.menuContentOpened false
      Router.go @slug()

  # ViewModel for the menu's items on links
  Template.navLink.viewmodel (data) ->
    id: data._id
    page: -> BasicPages.findOne @id()
    slug: -> @page().slug
    name: -> @page().title
    changeRoute: (e) ->
      e.preventDefault()
      mainMenuModel.menuContentOpened false
      Router.go @slug()
