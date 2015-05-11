Router.configure
  layoutTemplate: 'layout'

if Meteor.isClient
  Router.plugin 'seo', defaults:
    title: orion.dictionary.get 'site.title'
    suffix: orion.dictionary.get 'site.title'
    separator: '-'
    description: orion.dictionary.get 'site.description'

Router.map ->
  @route '/home',
    path: '/'
    seo:
      title: -> orion.dictionary.get 'site.title'
      suffix: null
      meta:
        description: -> orion.dictionary.get 'site.description'
