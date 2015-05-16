_enterAnimation = 'fadeIn'
_leaveAnimation = 'fadeOut'
_animate = ($el, anim, next) ->
  $el.addClass(anim).on ANIMATION_END_EVENT, ->
    $(this).removeClass anim
    next and next()

# All main section that are not the initial spinner
MAIN_SECTION = '.main-container:not([data-role=\'spinner\'])'

Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'
  onAfterAction: ->
    _animate ($ MAIN_SECTION), _enterAnimation
    Meteor.setTimeout ->
      ($ MAIN_SECTION).css 'opacity', 1
    , 64

if Meteor.isClient
  Router.plugin 'seo', defaults:
    title: orion.dictionary.get 'site.title'
    suffix: orion.dictionary.get 'site.title'
    separator: '-'
    description: orion.dictionary.get 'site.description'

Router.map ->
  # @route 'home',
  #   seo:
  #     title: -> orion.dictionary.get 'site.title'
  #     suffix: null
  #     meta:
  #       description: -> orion.dictionary.get 'site.description'
  # @route 'test',
  #   layoutTemplate: 'testLayout'
