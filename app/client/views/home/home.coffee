@mainCntEl = '.main-container[data-role=\'layout\']'
@menuEl = "#{mainCntEl}>nav"
@routerEl = "#{mainCntEl}>.router-container"
@videoEl = "#{routerEl}>video"
@mainEl = "#{routerEl}>main"
@headerEl = "#{routerEl}>header>section"
@logoEl = "#{headerEl}>.center-all>.svg-logo-container"
@arrowEl = "#{headerEl}>.arrow-down-container>.arrow-down-centered"
@programCntEl = "#{mainEl}>section:nth-child(1)"
@prezEl = "#{programCntEl}>article:nth-child(1)"
@progEl = "#{programCntEl}>article:nth-child(2)"
@subEl = "#{mainEl}>section:nth-child(2)>article"
@contactEl = "#{mainEl}>section:nth-child(3)>article"
@mapEl = "#{mainEl}>section.map>.map-container"

class @ScrollerSingleton
  instance = null
  class Scroller
    constructor: ->
      @scrollPos = 0
    sizeAndPos: ->
      @posEndAnimLogo = @$header.height()
      @logoTop = @$logo.offset().top
    start: ->
      @$mainCntEl = $ mainCntEl
      @$header = $ headerEl
      @posStartAnimLogo = 20
      @$logo = $ logoEl
      @sizeAndPos()
      @$mainCntEl.on 'scroll', => @event()
    event: ->
      @scrollPos = @$mainCntEl.scrollTop()
      trans = (@scrollPos-@posStartAnimLogo) * .6
      scale = if @scrollPos > @logoTop
        1 + .001 * (@scrollPos - @logoTop)
      else 1
      @$logo.css 'transform',
        "translate3d(0,#{trans}px, 1px) scale3d(#{scale}, #{scale}, 1)"
    resizing: ->
      @sizeAndPos()
      @event()
    stop: ->
      @$mainCntEl.off 'scroll'
  @get: ->
    instance ?= new Scroller

Template.home.onCreated ->
  @rxMainHeight = new ReactiveVar
  ($ window).on 'resize', _.debounce =>
    @rxMainHeight.set ($ mainEl).height()
  , 256

Template.home.onRendered ->
  Session.set 'debug', if IS_MOBILE then 'mobile' else 'desktop'
  # Set menu as invisible on the home page uniquely
  ($ menuEl).css 'opacity', 0
  # Start scrolling container
  ScrollerSingleton.get().start()
  # Set reactive height
  @rxMainHeight.set ($ mainCntEl).height()
  @autorun (computation) =>
    # Use reactivity to handle resizing
    mainHeight = @rxMainHeight.get()
    # Handle resizing on Scroller except on the first instanciation
    unless computation.firstRun
      ScrollerSingleton.get().resizing()
      # Recreates waypoints
      Waypoint.destroyAll()
    $mainCntEl = $ mainCntEl
    winHeight = ($ window).height()
    # Waypoint on the arrow and trigger menu visibility
    new Waypoint
      element: ($ arrowEl)[0]
      handler: (direction) ->
        if direction is 'down'
          ($ arrowEl).css 'opacity', 0
          ($ menuEl).css 'opacity', 1
          ($ prezEl).velocity('stop').velocity 'transition.slideLeftIn'
          ($ progEl).velocity('stop').velocity 'transition.slideRightIn'
        else
          ($ arrowEl).css 'opacity', 1
          ($ menuEl).css 'opacity', 0
          ($ prezEl).velocity('stop').velocity 'reverse'
          ($ progEl).velocity('stop').velocity 'reverse'
      offset: ($ headerEl).height()*.7
      context: $mainCntEl[0]
    # Waypoint for stopping the video and the Scroller
    new Waypoint
      element: ($ arrowEl)[0]
      handler: (direction) ->
        if direction is 'down'
          ScrollerSingleton.get().stop()
          ($ videoEl)?.hide()
        else
          ScrollerSingleton.get().start()
          ($ videoEl)?.show()
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
    # Waypoint contact content that triggers entrance animation
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

Template.home.helpers
  isMobile: -> IS_MOBILE
