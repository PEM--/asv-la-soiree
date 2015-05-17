# All main section that are not the initial spinner
MAIN_SECTION = '.main-container:not([data-role=\'spinner\'])'

Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'
  # Used for Google universal analytics
  trackPageView: true

if Meteor.isClient
  Router.plugin 'seo', defaults:
    title: orion.dictionary.get 'site.title'
    suffix: orion.dictionary.get 'site.title'
    separator: '-'
    description: orion.dictionary.get 'site.description'

@navLinks = [
  { name: 'Programme', slug: '/program' }
  { name: 'Inscription en ligne', slug: '/subscription' }
  { name: 'Contact', slug: '/contact' }
]

Router.map ->
  @route '/',
    name: 'home'
    seo:
      title: -> orion.dictionary.get 'site.title'
      suffix: null
      meta:
        description: -> orion.dictionary.get 'site.description'
  for navLink in navLinks
    @route navLink.slug
