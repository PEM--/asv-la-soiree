Template.home.onRendered ->
  ($ 'nav').css 'opacity', 0
  # Create a scrolling controller and scenes using ScrollMagic
  @controller = new ScrollMagic.Controller()
  @menuTween = new TweenMax.to 'nav', 1, opacity: 1
  @menuScene = new ScrollMagic.Scene triggerElement: 'main'
    .setTween @menuTween
    .addIndicators()
    .addTo @controller
  # @ctrl = new ScrollMagic.Controller()
  # @arrowTween = new TweenMax.to 'nav', 1, opacity: 0
  # @arrowScene = new ScrollMagic.Scene triggerElement: 'main'
  #   .setTween @arrowTween
  #   .addIndicators()
  #   .addTo @controller

Template.home.onDestroyed ->
  # Destroy controller and scenes
  @controller.destroy true
  @menuScene.destroy true
  # @arrowScene.destroy true
