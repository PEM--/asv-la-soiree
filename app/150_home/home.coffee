class @HomeController extends AppCtrl
  onRerun: ->
    if @ready()
      mainMenuModel.hide()
    @next()
  onAfterAction: ->
    if @ready()
      Meteor.setTimeout ->
        HomeController.scrollToFragment()
      , 300
  onStop: ->
    Waypoint.destroyAll()
    ScrollerSingleton.get().stop()
  # Public static methods and members
  @scrollToFragment = ->
    # Check for URL fragment
    URL = document.baseURI
    unless (URL.search '#') is -1
      fragment = (URL.split '#')[1]
      HomeController.scrollTo "[href='##{fragment}']:not([data-bound=true])",
        mainMenuModel.height()
  @scrollToTop = ->
    HomeController.scrollTo 'header', 0
  @$mainCntEl = null
  @scrollTo = (el, offset) ->
    HomeController.$mainCntEl = $ Router.mainCntEl \
      if HomeController.$mainCntEl is null
    $el = HomeController.$mainCntEl.find el
    $el.velocity 'scroll',
      container: HomeController.$mainCntEl
      duration: 600
      easing: 'ease'
      offset: -20 - offset
      mobileHA: false

appLog.info 'Adding home page'
Router.route '/', controller: HomeController, action: -> @render 'home'

if Meteor.isClient
  class @ScrollerSingleton
    instance = null
    logoEl = '.logo-resizer>.svg-logo-container'
    @get: ->
      instance ?= new Scroller
    class Scroller
      constructor: ->
        @scrollPos = 0
      start: ->
        @$mainCntEl = $ Router.mainCntEl
        @$header = @$mainCntEl.find 'header>section'
        @posStartAnimLogo = 0
        @$logo = @$header.find logoEl
        @sizeAndPos()
        # Scroll events are namespaced for avoiding collision with Waypoints
        @$mainCntEl.on 'scroll.scroller', => @event()
      sizeAndPos: ->
        @posEndAnimLogo = @$header.height()
        @logoTop = @$logo.offset().top
      event: ->
        @scrollPos = @$mainCntEl.scrollTop()
        trans = (@scrollPos-@posStartAnimLogo) * .8
        scale = if @scrollPos > @logoTop
          1 + .001 * (@scrollPos - @logoTop)
        else 1
        @$logo.css 'transform',
          "translate3d(0,#{trans}px, 1px) scale3d(#{scale}, #{scale}, 1)"
      resizing: ->
        @sizeAndPos()
        @event()
      stop: ->
        @$mainCntEl?.off 'scroll.scroller'

  Template.home.onCreated ->
    @rxMainHeight = new ReactiveVar
    ($ window).on 'resize', _.debounce =>
      @rxMainHeight.set ($ Router.mainCntEl).height()
    , if Session.get 'IS_MOBILE' then 256 else 1024

  changeMenuColor = (direction, isInverted) ->
    whiten = direction is 'up'
    whiten = not whiten if isInverted
    mainMenuModel.white whiten

  homeModel = new ViewModel
    arrowOpacity: 1
    teaserOpacity: 1
    goInnerLink: (e) ->
      e.preventDefault()
      window.location = e.currentTarget.href
      HomeController.scrollToFragment()

  Template.home.onCreated ->
    appLog.info 'Creating home screen'
  Template.home.onRendered ->
    appLog.info 'Rendering home screen'
    mainMenuModel.hide()
    homeModel.bind @
    Session.set 'debug', if Session.get 'IS_MOBILE' then 'mobile' else 'desktop'
    unless Session.get 'IS_MOBILE'
      # Start video
      # video = @find 'video'
      # video.play()
      # Start scrolling container
      ScrollerSingleton.get().start()
    # Set reactive height
    @rxMainHeight.set ($ Router.mainCntEl).height()
    @autorun (computation) =>
      # Use reactivity to handle resizing
      mainHeight = @rxMainHeight.get()
      # Handle resizing on Scroller except on the first instanciation
      unless computation.firstRun
        ScrollerSingleton.get().resizing() unless Session.get 'IS_MOBILE'
        # Recreates waypoints
        Waypoint.destroyAll()
      # Get all DOM elements of interest for the Waypoints
      $mainCntEl = Iron.controller().$mainCntEl
      $headerEl = @$ 'header>section'
      winHeight = ($ window).height()
      $arrowEl = $headerEl.find '.arrow-down-centered'
      $prezEl = @$ 'section:nth-child(1)>article:nth-child(1)'
      $progEl = @$ 'section:nth-child(1)>article:nth-child(2)'
      $subEl = @$ 'section:nth-child(2)>article'
      $contactEl = @$ 'section:nth-child(3)>article'
      $mapEl = @$ 'section.map>.map-container'
      # Waypoint on the arrow and trigger menu visibility
      $arrowEl.waypoint (direction) ->
        if direction is 'down'
          homeModel.arrowOpacity 0
          homeModel.teaserOpacity 0
          mainMenuModel.show()
          $prezEl.velocity('stop').velocity 'transition.slideLeftIn'
          $progEl.velocity('stop').velocity 'transition.slideRightIn'
        else
          homeModel.arrowOpacity 1
          homeModel.teaserOpacity 1
          mainMenuModel.hide()
          $prezEl.velocity('stop').velocity 'reverse'
          $progEl.velocity('stop').velocity 'reverse'
      ,
        offset: $headerEl.height()*.7
        context: Router.mainCntEl
      # Waypoint for stopping the video and the Scroller
      unless Session.get 'IS_MOBILE'
        $prezEl.waypoint (direction) ->
          if direction is 'down'
            ScrollerSingleton.get().stop()
            #video.pause()
          else
            ScrollerSingleton.get().start()
            #video.play()
        ,
          context: Router.mainCntEl
      # Waypoint subscription content that triggers entrance animation
      $subEl.waypoint (direction) ->
        if direction is 'down'
          $subEl.velocity('stop').velocity 'transition.slideUpIn'
        else
          $subEl.velocity('stop').velocity 'reverse'
      ,
        # Animations starts at 10% visibility of the content
        offset: winHeight - $subEl.height()*0.1
        context: $mainCntEl
      # Waypoint subscription content menu color change
      $subEl.waypoint (direction) -> changeMenuColor direction, true
      ,
        offset: mainMenuModel.height()
        context: $mainCntEl
      # Waypoint contact content that triggers entrance animation
      $contactEl.waypoint (direction) ->
        if direction is 'down'
          $contactEl.velocity('stop').velocity 'transition.slideUpIn'
        else
          $contactEl.velocity('stop').velocity 'reverse'
      ,
        # Animations starts at 10% visibility of the content
        offset: winHeight - $contactEl.height()*0.1
        context: $mainCntEl
      # Waypoint subscription content menu color change
      $contactEl.waypoint (direction) -> changeMenuColor direction, false
      ,
        offset: mainMenuModel.height()
        context: $mainCntEl
      # Waypoint mapEl content that triggers entrance animation
      $mapEl.waypoint (direction) ->
        if direction is 'down'
          $mapEl.velocity('stop').velocity 'transition.slideUpIn'
        else
          $mapEl.velocity('stop').velocity 'reverse'
      ,
        # Animations starts at 10% visibility of the content
        offset: winHeight - $mapEl.height()*0.1
        context: $mainCntEl
      # Waypoint map content menu color change
      $mapEl.waypoint (direction) -> changeMenuColor direction, true
      ,
        offset: mainMenuModel.height()
        context: $mainCntEl
