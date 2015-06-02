if Meteor.isClient
  @mainEl = "#{routerEl}>main"
  @headerEl = "#{routerEl}>header>section"
  @logoEl = "#{headerEl}>.center-all>.logo-resizer>.svg-logo-container"
  @arrowEl = "#{headerEl}>.arrow-down-container>.arrow-down-centered"
  @programCntEl = "#{mainEl}>section:nth-child(1)"
  @prezEl = "#{programCntEl}>article:nth-child(1)"
  @progEl = "#{programCntEl}>article:nth-child(2)"
  @subEl = "#{mainEl}>section:nth-child(2)>article"
  @contactEl = "#{mainEl}>section:nth-child(3)>article"
  @mapEl = "#{mainEl}>section.map>.map-container"

  class @ScrollerSingleton
    instance = null
    @get: ->
      instance ?= new Scroller
    class Scroller
      constructor: ->
        @scrollPos = 0
      sizeAndPos: ->
        @posEndAnimLogo = @$header.height()
        @logoTop = @$logo.offset().top
      start: ->
        @$mainCntEl = $ mainCntEl
        @$header = $ headerEl
        @posStartAnimLogo = 0
        @$logo = $ logoEl
        @sizeAndPos()
        @$mainCntEl.on 'scroll', => @event()
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
        @$mainCntEl?.off 'scroll'

  Template.home.onCreated ->
    @rxMainHeight = new ReactiveVar
    ($ window).on 'resize', _.debounce =>
      @rxMainHeight.set ($ mainEl).height()
    , if Session.get 'IS_MOBILE' then 256 else 1024

  changeMenuColor = (direction, isInverted) ->
    whiten = direction is 'up'
    whiten = not whiten if isInverted
    mainMenuModel.white whiten

  homeModel = new ViewModel
    arrowOpacity: 1
    teaserOpacity: 1

  Template.home.onCreated -> appLog.info 'Creating home screen'
  Template.home.onRendered ->
    appLog.info 'Rendering home screen'
    homeModel.bind @
    Session.set 'debug', if Session.get 'IS_MOBILE' then 'mobile' else 'desktop'
    unless Session.get 'IS_MOBILE'
      # Start video
      video = @find 'video'
      video.play()
      # Start scrolling container
      ScrollerSingleton.get().start()
    # Set menu as invisible on the home page uniquely
    # @TODO Must fix load ordering issues
    mainMenuModel.hide()
    # Set reactive height
    @rxMainHeight.set ($ mainCntEl).height()
    @autorun (computation) =>
      # Use reactivity to handle resizing
      mainHeight = @rxMainHeight.get()
      # Handle resizing on Scroller except on the first instanciation
      unless computation.firstRun
        ScrollerSingleton.get().resizing() unless Session.get 'IS_MOBILE'
        # Recreates waypoints
        Waypoint.destroyAll()
      $mainCntEl = $ mainCntEl
      winHeight = ($ window).height()
      # Waypoint on the arrow and trigger menu visibility
      new Waypoint
        element: ($ arrowEl)[0]
        handler: (direction) ->
          if direction is 'down'
            homeModel.arrowOpacity 0
            homeModel.teaserOpacity 0
            mainMenuModel.show()
            ($ prezEl).velocity('stop').velocity 'transition.slideLeftIn'
            ($ progEl).velocity('stop').velocity 'transition.slideRightIn'
          else
            homeModel.arrowOpacity 1
            homeModel.teaserOpacity 1
            mainMenuModel.hide()
            ($ prezEl).velocity('stop').velocity 'reverse'
            ($ progEl).velocity('stop').velocity 'reverse'
        offset: ($ headerEl).height()*.7
        context: $mainCntEl[0]
      # Waypoint for stopping the video and the Scroller
      unless Session.get 'IS_MOBILE'
        new Waypoint
          element: ($ arrowEl)[0]
          handler: (direction) ->
            if direction is 'down'
              ScrollerSingleton.get().stop()
              video.pause()
            else
              ScrollerSingleton.get().start()
              video.play()
        context: $mainCntEl[0]
      # Waypoint subscription content that triggers entrance animation
      new Waypoint
        element: ($ subEl)[0]
        handler: (direction) ->
          if direction is 'down'
            ($ subEl).velocity('stop').velocity 'transition.slideUpIn'
          else
            ($ subEl).velocity('stop').velocity 'reverse'
        # Animations starts at 10% visibility of the content
        offset: winHeight - ($ subEl).height()*0.1
        context: $mainCntEl[0]
      # Waypoint subscription content menu color change
      new Waypoint
        element: ($ subEl)[0]
        handler: (direction) -> changeMenuColor direction, true
        offset: mainMenuModel.height()
        context: $mainCntEl[0]
      # Waypoint contact content that triggers entrance animation
      new Waypoint
        element: ($ contactEl)[0]
        handler: (direction) ->
          if direction is 'down'
            ($ contactEl).velocity('stop').velocity 'transition.slideUpIn'
          else
            ($ contactEl).velocity('stop').velocity 'reverse'
        # Animations starts at 10% visibility of the content
        offset: winHeight - ($ contactEl).height()*0.1
        context: $mainCntEl[0]
      # Waypoint subscription content menu color change
      new Waypoint
        element: ($ contactEl)[0]
        handler: (direction) -> changeMenuColor direction, false
        offset: mainMenuModel.height()
        context: $mainCntEl[0]
      # Waypoint mapEl content that triggers entrance animation
      new Waypoint
        element: ($ mapEl)[0]
        handler: (direction) ->
          if direction is 'down'
            ($ mapEl).velocity('stop').velocity 'transition.slideUpIn'
          else
            ($ mapEl).velocity('stop').velocity 'reverse'
        # Animations starts at 10% visibility of the content
        offset: winHeight - ($ mapEl).height()*0.1
        context: $mainCntEl[0]
      # Waypoint map content menu color change
      new Waypoint
        element: ($ mapEl)[0]
        handler: (direction) -> changeMenuColor direction, true
        offset: mainMenuModel.height()
        context: $mainCntEl[0]
