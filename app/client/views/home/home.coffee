Template.home.onRendered ->
  ($ 'nav').css 'opacity', 0
  # Create a scrolling controller and scenes using ScrollMagic
  @controller = new ScrollMagic.Controller
  @blockTween = new TweenMax.to 'nav', 1, opacity: 1
  @menuScene = new ScrollMagic.Scene
    triggerElement: 'main'
  .setTween @blockTween
  # Debug mode
  #.addIndicators()
  .addTo @controller

Template.home.onDestroyed ->
  # Destroy controller and scenes
  @controller.destroy true
  @menuScene.destroy true
