# Social messages
orion.dictionary.addDefinition 'twitter.message', 'social',
  type: String, label: 'Message par défaut pour Twitter'
orion.dictionary.addDefinition 'gplus.message', 'social',
  type: String, label: 'Message par défaut pour Google+'
orion.dictionary.addDefinition 'youtube.url', 'social',
  type: String, label: 'Adresse YouTube'

if Meteor.isServer
  @socialValues = ->
    res = {}
    for key in [
      'social.twitter.message'
      'social.gplus.message'
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
    faceBookUrl: ->
      FB_URL = 'https://www.facebook.com/sharer/sharer.php'
      siteUrl = Meteor.settings.public.proxy.url
      FB_URL + '?u=' + encodeURIComponent siteUrl
      # https://twitter.com/intent/tweet?source=http%3A%2F%2Fasv-la-soiree.com&text=La%20soir%C3%A9e%20ASV:%20http%3A%2F%2Fasv-la-soiree.com&via=apform
    youtubeURL: -> orion.dictionary.get 'social.youtube.url'
