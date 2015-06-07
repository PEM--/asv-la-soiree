class @BasicPageController extends AppCtrl
  onRun: -> appLog.warn 'BasicPageController: onRun', @
  onRerun: ->
    appLog.warn 'BasicPageController: onReRun', @
    mainMenuModel.white false
    mainMenuModel.show()
    @next()
  onBeforeAction: ->
    appLog.warn 'BasicPageController: onBeforeAction'
    @next()
  onAfterAction: ->
    appLog.warn 'BasicPageController: onAfterAction'
  onStop: ->
    appLog.warn 'BasicPageController: onStop'
    @$mainCntEl.scrollTop 0

if Meteor.isClient
  Template.basicPage.onCreated ->
    appLog.info 'Basic page created for', @data.slug

  Template.basicPage.onRendered ->
    appLog.info 'Basic page rendered'

  Template.basicPage.helpers
    transition: -> (from, to, element) -> 'myFade'
