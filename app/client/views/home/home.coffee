class @ScrollerSingleton
  instance = null
  class Scroller
    menuEl = '.main-container>nav'
    mainEl = '.main-container>.router-container>main'
    #logoEl = '.main-container>.router-container>header>section>.s'
    arrowEl = '.main-container>.router-container>header>section>.arrow-down'
    createScenes: ->
      @scCtrl = new ScrollMagic.Controller
      menuTween = new TweenMax.to menuEl, 1,
        opacity: 1
      @menuScene = new ScrollMagic.Scene
        triggerElement: mainEl
        offset: -100
      @menuScene.setTween menuTween
        #.addIndicators()
        .addTo @scCtrl
      arrowTween = new TweenMax.to arrowEl, 1,
        webkitAnimation: 'none'
        animation: 'none'
        opacity: 0
      @arrowScene = new ScrollMagic.Scene
        triggerElement: mainEl
        offset: -150
      @arrowScene.setTween arrowTween
        #.addIndicators()
        .addTo @scCtrl
    destroyScenes: ->
      @scCtrl.destroy true
      @menuScene?.destroy true
      @arrowScene?.destroy true
  @get: ->
    instance ?= new Scroller

Template.home.onRendered ->
  console.log 'Home rendered'
  ($ 'nav')
    .css 'webkitOpacity', 0
    .css 'opacity', 0
  # Create a scrolling controller and scenes using ScrollMagic
  ScrollerSingleton.get().createScenes()
