# class @ScrollerSingleton
#   instance = null
#   class Scroller
#     mainContainer = '.main-container'
#     menuEl = "#{mainContainer}>nav"
#     routerContainer = "#{mainContainer}>.router-container"
#     mainEl = "#{routerContainer}>main"
#     headerEl = "#{routerContainer}>header"
#     logoEl = "#{headerEl}>section>.center-all"
#     arrowEl = "#{headerEl}>section>.arrow-down>.arrow-down-centered"
#     createScenes: ->
#       headerHeight = ($ headerEl).height()
#       @scCtrl = new ScrollMagic.Controller
#         container: mainContainer
#       # Remove the arrow when user starts scroling
#       @arrowScene = new ScrollMagic.Scene
#         triggerElement: mainEl
#         offset: -headerHeight*.4
#       .setTween arrowEl, 1, opacity: 0
#       .addIndicators()
#       # Show the menu when user reaches the end of the landing page
#       @menuScene = new ScrollMagic.Scene
#         triggerElement: mainEl
#         offset: -headerHeight*.4
#       .setTween menuEl, 1, opacity: 1
#       .addIndicators()
#       # Slow down logo scrolling and scale it
#       @logoScene = new ScrollMagic.Scene
#         triggerElement: mainEl
#         offset: -headerHeight*.5
#         duration: headerHeight
#       .setTween logoEl, 1,
#         y: headerHeight*.55
#         ease: Linear.easeNone
#       .addIndicators()
#       @scCtrl.addScene [@arrowScene, @menuScene, @logoScene]
#     destroyScenes: ->
#       @scCtrl?.destroy true
#       @menuScene?.destroy true
#       @arrowScene?.destroy true
#       @logoScene?.destroy true
#   @get: ->
#     instance ?= new Scroller

Template.home.onCreated ->
  @winSize = new ReactiveVar
  @winScroll = new ReactiveVar

Template.home.onRendered ->
  ($ 'nav')
    .css 'webkitOpacity', 0
    .css 'opacity', 0
  # Create a scrolling controller and scenes using ScrollMagic
  # ScrollerSingleton.get().createScenes()
  # ($ '.main-container').on 'scroll', (e) ->
  #   console.log 'jQuery scroll', e
  # ($ window).on 'resize', (e) ->
  #   console.log 'jQuery resize', e
  @autorun (comp) ->
    console.log 'Recalculate', comp
    unless comp.firstRun
      size = @winSize.get()
      scroll = @winScroll.get()

# Template['.main-container'].events
#   'scroll': -> console.log 'Scrolling?'

Template.body.events
  'resize': -> console.log 'Resizing?'
  'keypress': -> console.log 'Key pressed?'

Template.home.events ->
  'onscroll': ->
    console.log 'Scrolling'
