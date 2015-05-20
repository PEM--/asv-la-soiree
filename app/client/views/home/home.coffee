@mainCntEl = '.main-container[data-role=\'layout\']'
@menuEl = "#{mainCntEl}>nav"
@routerEl = "#{mainCntEl}>.router-container"
@mainEl = "#{routerEl}>main"
@headerEl = "#{routerEl}>header>section"
@logoEl = "#{headerEl}>.center-all>.svg-logo-container"
@arrowEl = "#{headerEl}>.arrow-down>.arrow-down-centered"

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
  # Waypoint on the arrow and trigger menu visibility
  ($ arrowEl).waypoint (direction) ->
    if direction is 'down'
      ($ @).css 'opacity', 0
      ($ menuEl).css 'opacity', 1
    else
      ($ @).css 'opacity', 1
      ($ menuEl).css 'opacity', 0
  ,
    offset: ($ headerEl).height()*.7
    context: mainCntEl

Template.home.onDestroyed ->
  # Stop scolling container
  ScrollerSingleton.get().stop()
