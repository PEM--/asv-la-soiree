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
  onAfterAction: -> appLog.warn 'BasicPageController: onAfterAction'
  onStop: ->
    appLog.warn 'BasicPageController: onStop'

if Meteor.isClient
  Template.basicPage.transition = ->
    appLog.error 'Momentum?'
    with: 'fade'

  Template.basicPage.onCreated ->
    appLog.error 'basicPage recreated'
    appLog.info 'Basic page created for', @data.slug, @data.title

  Template.basicPage.onRendered ->
    appLog.info 'Basic page rendered'
