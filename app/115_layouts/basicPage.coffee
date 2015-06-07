class @BasicPageController extends AppCtrl
  onRerun: ->
    mainMenuModel.white false
    mainMenuModel.show()
    @$mainCntEl.scrollTop 0
    @next()
  # onStop: ->
  #   appLog.warn 'BasicPageController: onStop: Pas de scroll'

if Meteor.isClient
  Template.basicPage.onCreated ->
    appLog.info 'Basic page created for', @data.slug

  Template.basicPage.onRendered ->
    appLog.info 'Basic page rendered'

  Template.basicPage.helpers
    transition: -> (from, to, element) -> 'myFade'
