@mainCntEl = '.main-container[data-role=\'layout\']'
@menuEl = "#{mainCntEl}>nav"
@routerContainer = "#{mainCntEl}>.router-container"
@mainEl = "#{routerContainer}>main"
@headerEl = "#{routerContainer}>header"
@logoEl = "#{headerEl}>section>.center-all>.svg-logo-container"
@arrowEl = "#{headerEl}>section>.arrow-down>.arrow-down-centered"

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
  ($ 'nav')
    .css 'webkitOpacity', 0
    .css 'opacity', 0
  # Start scrolling container
  ScrollerSingleton.get().start()
  # Set waypoints
  ($ arrowEl).waypoint
    element: ($ @mainCntEl)[0]
    handler: -> console.log 'started'
    offset: 10

Template.home.onDestroyed ->
  # Stop scolling container
  ScrollerSingleton.get().stop()
