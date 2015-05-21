@mainCntEl = '.main-container[data-role=\'layout\']'
@menuEl = "#{mainCntEl}>nav"
@routerEl = "#{mainCntEl}>.router-container"
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
    event: ->
      @scrollPos = @$mainCntEl.scrollTop()
      trans = (@scrollPos-@posStartAnimLogo) * .6
      scale = if @scrollPos > @logoTop
        1 + .001 * (@scrollPos - @logoTop)
      else 1
      @$logo.css 'transform',
        "translate3d(0,#{trans}px, 0) scale3d(#{scale}, #{scale}, 1)"
    start: ->
      @$mainCntEl = $ mainCntEl
      @$header = $ headerEl
      @posStartAnimLogo = 20
      @$logo = $ logoEl
      @sizeAndPos()
      @$mainCntEl.on 'scroll', => @event()
      @$mainCntEl.on 'resize', _.throttle =>
        @sizeAndPos()
        @event()
    stop: ->
      @$mainCntEl.off 'scroll'
      @$mainCntEl.off 'resize'
  @get: ->
    instance ?= new Scroller

Template.home.onRendered ->
  # Set menu as invisible on the home page uniquely
  ($ menuEl).css 'opacity', 0
  # Start scrolling container
  ScrollerSingleton.get().start()
  # @TODO Resizing à vérifier + ReactiveVar & Autorun
  # Waypoint on the arrow and trigger menu visibility
  new Waypoint
    element: ($ arrowEl)[0]
    handler: (direction) ->
      if direction is 'down'
        ($ arrowEl).velocity opacity: 0
        ($ menuEl).velocity opacity: 1
        ($ prezEl).velocity 'transition.slideLeftIn', display: null
        ($ progEl).velocity 'transition.slideRightIn', display: null
      else
        ($ arrowEl).velocity opacity: 1
        ($ menuEl).velocity opacity: 0
        ($ prezEl).velocity 'transition.slideLeftOut', display: null
        ($ progEl).velocity 'transition.slideRightOut', display: null
    offset: ($ headerEl).height()*.7
    context: ($ mainCntEl)[0]
  # Waypoint subscription content that triggers entrance animation
  new Waypoint
    element: ($ subEl)[0]
    handler: (direction) ->
      if direction is 'down'
        ($ subEl).velocity 'transition.flipXIn', display: null
      else
        ($ subEl).velocity 'transition.flipXOut', display: null
    # Animations starts at 10% visibility of the content
    offset: $(window).height() - ($ subEl).height()*0.1
    context: ($ mainCntEl)[0]
  # Waypoint contact content that triggers entrance animation
  new Waypoint
    element: ($ contactEl)[0]
    handler: (direction) ->
      if direction is 'down'
        ($ contactEl).velocity 'transition.bounceIn', display: null
      else
        ($ contactEl).velocity 'transition.bounceOut', display: null
    # Animations starts at 10% visibility of the content
    offset: $(window).height() - ($ contactEl).height()*0.1
    context: ($ mainCntEl)[0]
  # Waypoint contact content that triggers entrance animation
  new Waypoint
    element: ($ mapEl)[0]
    handler: (direction) ->
      if direction is 'down'
        ($ mapEl).velocity 'transition.fadeIn', display: null
      else
        ($ mapEl).velocity 'transition.fadeOut', display: null
    # Animations starts at 10% visibility of the content
    offset: $(window).height() - ($ mapEl).height()*0.1
    context: ($ mainCntEl)[0]

Template.home.onDestroyed ->
  # Stop scolling container
  ScrollerSingleton.get().stop()
