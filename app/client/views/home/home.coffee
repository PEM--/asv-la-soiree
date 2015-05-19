
@scCtrl = new ScrollMagic.Controller

Template.home.onRendered ->
  # Create a scrolling controller and scenes using ScrollMagic
  ($ 'nav')
    .css 'webkitOpacity', 0
    .css 'opacity', 0
  menuEl = '.main-container>nav'
  mainEl = '.main-container>.router-container>main'
  #logoEl = '.main-container>.router-container>header>section>.s'
  arrowEl = '.main-container>.router-container>header>section>.arrow-down'
  menuTween = new TweenMax.to menuEl, 1,
    opacity: 1
  menuScene = new ScrollMagic.Scene
    triggerElement: mainEl
    offset: -100
  menuScene.setTween menuTween
    .addIndicators()
    .addTo scCtrl
  arrowTween = new TweenMax.to arrowEl, 1,
    webkitAnimation: 'none'
    animation: 'none'
    opacity: 0
  arrowScene = new ScrollMagic.Scene
    triggerElement: mainEl
    offset: -150
  arrowScene.setTween arrowTween
    .addIndicators()
    .addTo scCtrl

Template.home.onDestroyed ->
  # Destroy controller and scenes
  #@controller.destroy true
  #@menuScene.destroy true
  # @arrowScene.destroy true
