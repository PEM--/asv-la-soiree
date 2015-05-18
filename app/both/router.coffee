# All main section that are not the initial spinner
MAIN_SECTION = '.main-container:not([data-role=\'spinner\'])'

Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'
  # Used for Google universal analytics
  trackPageView: true

# Global router function ensuring to get the current slug.
# When reloading a page or getting a direct acces, the reactive
# value Router.current().url provides the full URL but when
# activated inside the client app, it returns the slug.
# This function ensure that only the slug is returned.
Router.getSlug = ->
  curUrl = Router.current().url
  count = curUrl.search __meteor_runtime_config__.ROOT_URL
  return curUrl if count is -1
  curUrl.substr __meteor_runtime_config__.ROOT_URL.length - 1

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
