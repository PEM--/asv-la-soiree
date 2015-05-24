class @MainMenuSingleton
  instance = null
  menuEl = 'nav'
  menuLogoEl = "#{menuEl} svg"
  menuContentEl = "#{menuEl} ul"
  @get: (t = null) ->
    return if t is null and instance is null
    instance ?= new MainMenu t
  class MainMenu
    constructor: (t) ->
      @template = t unless t is null
      @$mainMenu = t.$ menuEl
      @$menuLogo = t.$ menuLogoEl
      @$menuContent = t.$ menuContentEl
      console.log 'DOM', @$mainMenu, @$menuLogo, @$menuContent
    height: ->
      console.log 'Height'
      @$mainMenu.height()
    show: ->
      console.log 'Show'
      @$mainMenu.css 'opacity', 1
    hide: ->
      console.log 'Hide'
      @$mainMenu.css 'opacity', 0

Template.nav.onRendered ->
  console.log 'Nav instanciation', @
  # Initialize the menu singleton on the menu template
  MainMenuSingleton.get @

Template.nav.viewmodel 'mainMenu',
  white: false
  menuContentOpened: false
  goHome: ->
    @menuContentOpened false
    goNextRoute '/'
  hamburger: (e) -> @menuContentOpened not @menuContentOpened()
  changeRoute: (e) ->
    e.preventDefault()
    @menuContentOpened false
    goNextRoute e.target.pathname
  blaze_helpers: ->
    # These elements are stored in a regular Blaze helpers as they
    #  are using global values that ViewModel doesn't handle.
    # @TODO Set these in a regular ViewModel
    links: -> navLinks
    activeRoute: ->
      curSlug = getSlug()
      if @slug is curSlug then 'active' else ''
