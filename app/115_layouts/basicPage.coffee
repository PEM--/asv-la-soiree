if Meteor.isClient
  Template.basicPage.onCreated ->
    appLog.info 'Basic page created for', @data.slug, @data.title

  Template.basicPage.onRendered ->
    appLog.info 'Basic page rendered'
