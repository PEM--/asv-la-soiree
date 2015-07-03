class @HomeController extends AppCtrl
  onRerun: ->
    mainMenuModel.hide() if @ready()
    @next()
  onAfterAction: ->
    if @ready()
      HomeController.$mainCntEl = $ Router.mainCntEl
      Meteor.setTimeout (-> HomeController.scrollToFragment()), 300
  onStop: ->
    Waypoint.destroyAll()
    ScrollerSingleton.get().stop() unless IS_MOBILE
  # Public static methods and members
  @scrollToFragment = ->
    # Check for URL fragment
    URL = document.baseURI
    unless (URL.search '#') is -1
      fragment = (URL.split '#')[1]
      HomeController.scrollTo \
        (HomeController.$mainCntEl.find "section.#{fragment}"),
        -(mainMenuModel.height() - 1)
  @scrollToTop = ->
    HomeController.scrollTo (HomeController.$mainCntEl.find 'header'), 0
  @$mainCntEl = null
  @scrollTo = ($el, offset) ->
    $el.velocity 'scroll',
      container: HomeController.$mainCntEl
      duration: 600
      easing: 'ease'
      offset: offset
      mobileHA: false

appLog.info 'Adding home page'
Router.route '/', controller: HomeController, action: -> @render 'home'

if Meteor.isClient
  class @ScrollerSingleton
    instance = null
    logoEl = '.logo-resizer>.svg-logo-container'
    @get: -> instance
    @instanciate: ($mainCntEl, tpl) -> instance = new Scroller $mainCntEl, tpl
    class Scroller
      constructor: (@$mainCntEl, @tpl) ->
        @scrollPos = 0
      start: ->
        appLog.info 'Scroller started'
        @$header = @tpl.$ 'header>section'
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
        appLog.info 'Scroller stopped'
        @$mainCntEl?.off 'scroll.scroller'

  Template.home.onCreated ->
    appLog.info 'Creating home screen'
    @rxMainHeight = new ReactiveVar
    ($ window).on 'resize', _.debounce =>
      @rxMainHeight.set ($ Router.mainCntEl).height()
    , if IS_MOBILE then 256 else 1024

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

  Template.home.onRendered ->
    appLog.info 'Rendering home screen'
    mainMenuModel.hide()
    homeModel.bind @
    Session.set 'debug', if IS_MOBILE then 'mobile' else 'desktop'
    # Set reactive height
    $mainCntEl = Iron.controller().$mainCntEl
    @rxMainHeight.set $mainCntEl.height()
    unless IS_MOBILE
      # Start video
      # video = @find 'video'
      # video.play()
      # Start scrolling container
      scrolInst = ScrollerSingleton.instanciate $mainCntEl, @
      ScrollerSingleton.get().start()
    ClockSingleton.get().start()
    @autorun (computation) =>
      # Use reactivity to handle resizing
      mainHeight = @rxMainHeight.get()
      # Handle resizing on Scroller except on the first instanciation
      unless computation.firstRun
        ScrollerSingleton.get().resizing() unless IS_MOBILE
        # Recreates waypoints
        Waypoint.destroyAll()
      # Get all DOM elements of interest for the Waypoints
      $headerEl = @$ 'header>section'
      winHeight = ($ window).height()
      $arrowEl = $headerEl.find '.arrow-down-centered'
      $sectionPrezEl = @$ 'section.program'
      $prezEl = $sectionPrezEl.find 'article:nth-child(1)'
      $progEl = $sectionPrezEl.find 'article:nth-child(2)'
      $sectionSubEl = @$ 'section.subscription'
      $subEl = $sectionSubEl.find 'article'
      $sectionContactEl = @$ 'section.contact'
      $contactEl = $sectionContactEl.find 'article'
      $sectionMapEl = @$ 'section.map'
      $mapEl = $sectionMapEl.find '.map-container'
      # Waypoint on the arrow and trigger menu visibility
      if IS_MOBILE
        $prezEl.css 'opacity', 1
        $progEl.css 'opacity', 1
      $arrowEl.waypoint (direction) ->
        if direction is 'down'
          mainMenuModel.show()
          unless IS_MOBILE
            homeModel.arrowOpacity 0
            homeModel.teaserOpacity 0
            $prezEl.velocity('stop').velocity 'transition.slideLeftIn'
            $progEl.velocity('stop').velocity 'transition.slideRightIn'
          ClockSingleton.get().stop()
        else
          mainMenuModel.hide()
          unless IS_MOBILE
            homeModel.arrowOpacity 1
            homeModel.teaserOpacity 1
            $prezEl.velocity('stop').velocity 'reverse'
            $progEl.velocity('stop').velocity 'reverse'
          ClockSingleton.get().start()
      ,
        offset: $headerEl.height()*.7
        context: $mainCntEl
      # Waypoint for stopping the video and the Scroller
      unless IS_MOBILE
        $sectionPrezEl.waypoint (direction) ->
          if direction is 'down'
            ScrollerSingleton.get().stop()
            #video.pause()
          else
            ScrollerSingleton.get().start()
            #video.play()
        ,
          context: $mainCntEl
      # Waypoint subscription content that triggers entrance animation
      if IS_MOBILE
        $subEl.css 'opacity', 1
      else
        $sectionSubEl.waypoint (direction) ->
          if direction is 'down'
            $subEl.velocity('stop').velocity 'transition.slideUpIn'
          else
            $subEl.velocity('stop').velocity 'reverse'
        ,
          # Animations starts at 10% visibility of the content
          offset: winHeight - $sectionSubEl.height()*0.1
          context: $mainCntEl
      # Waypoint subscription content menu color change
      $sectionSubEl.waypoint (direction) ->
        changeMenuColor direction, true
      ,
        offset: mainMenuModel.height()
        context: $mainCntEl
      # Waypoint contact content that triggers entrance animation
      if IS_MOBILE
        $contactEl.css 'opacity', 1
      else
        $sectionContactEl.waypoint (direction) ->
          if direction is 'down'
            $contactEl.velocity('stop').velocity 'transition.slideUpIn'
          else
            $contactEl.velocity('stop').velocity 'reverse'
        ,
          # Animations starts at 10% visibility of the content
          offset: winHeight - $sectionContactEl.height()*0.1
          context: $mainCntEl
      # Waypoint subscription content menu color change
      $sectionContactEl.waypoint (direction) ->
        changeMenuColor direction, false
      ,
        offset: mainMenuModel.height()
        context: $mainCntEl
      # Waypoint mapEl content that triggers entrance animation
      if IS_MOBILE
        $mapEl.css 'opacity', 1
      else
        $sectionMapEl.waypoint (direction) ->
          if direction is 'down'
            $mapEl.velocity('stop').velocity 'transition.slideUpIn'
          else
            $mapEl.velocity('stop').velocity 'reverse'
        ,
          # Animations starts at 10% visibility of the content
          offset: winHeight - $sectionMapEl.height()*0.1
          context: $mainCntEl
      # Waypoint map content menu color change
      $sectionMapEl.waypoint (direction) ->
        changeMenuColor direction, true
      ,
        offset: mainMenuModel.height()
        context: $mainCntEl
