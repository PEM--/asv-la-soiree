# Social messages
orion.dictionary.addDefinition 'twitter.message', 'social',
  type: String, label: 'Message par défaut pour Twitter'
orion.dictionary.addDefinition 'facebook.message', 'social',
  type: String, label: 'Message par défaut pour FaceBook'
orion.dictionary.addDefinition 'gplus.message', 'social',
  type: String, label: 'Message par défaut pour Google+'
orion.dictionary.addDefinition 'youtube.url', 'social',
  type: String, label: 'Adresse YouTube'

if Meteor.isServer
  @socialValues = ->
    res = {}
    for key in [
      'social.twitter.message'
      'social.facebook.message'
      'social.gplus.message'
      'social.youtube.url'
    ]
      orionDictKey = orion.dictionary.get key
      res[key] = if orionDictKey is ''
        eval "Meteor.settings.dictionary.#{key}"
      else
        orionDictKey
    res

# https://www.youtube.com/channel/UCJeNxRQgeyg92tRlBXpnvLg
if Meteor.isClient
  Template.socials.viewmodel
    faceBookUrl: ->
      FB_URL = 'https://www.facebook.com/sharer/sharer.php'
    shareOnFaceBook: ->
      window.open @faceBookUrl()
      return false

      window.open('https://www.facebook.com/sharer/sharer.php?u=' + encodeURIComponent(document.URL) + '&t=' + encodeURIComponent(document.URL)); return false;
