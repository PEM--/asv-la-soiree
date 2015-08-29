# Social messages
orion.dictionary.addDefinition 'twitter.message', 'social',
  type: String, label: 'Message par défaut pour Twitter'
orion.dictionary.addDefinition 'youtube.url', 'social',
  type: String, label: 'Adresse YouTube'

if Meteor.isServer
  @socialValues = ->
    res = {}
    for key in [
      'social.twitter.message'
      'social.youtube.url'
    ]
      orionDictKey = orion.dictionary.get key
      res[key] = if orionDictKey is ''
        eval "Meteor.settings.dictionary.#{key}"
      else
        orionDictKey
    res

if Meteor.isClient
  Template.socials.viewmodel
    facebookURL: ->
      FB_URL = 'https://www.facebook.com/sharer/sharer.php'
      siteUrl = Meteor.settings.public.proxy.url
      FB_URL + '?u=' + encodeURIComponent siteUrl
    twitterURL: ->
      TWITTER_URL = 'https://twitter.com/intent/tweet'
      siteUrl = Meteor.settings.public.proxy.url
      msg = orion.dictionary.get 'social.twitter.message'
      TWITTER_URL + '?source=' + (encodeURIComponent siteUrl) +
        '&text=' + (encodeURIComponent msg) +
        '&via=' + orion.dictionary.get('social.twitter.site')?.substr(1)
    gplusURL: ->
      GPLUS_URL = 'https://plus.google.com/share'
      siteUrl = Meteor.settings.public.proxy.url
      GPLUS_URL + '?url=' + encodeURIComponent siteUrl
    youtubeURL: -> orion.dictionary.get 'social.youtube.url'
