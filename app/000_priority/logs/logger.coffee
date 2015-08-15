@appLog = new bunyan.createLogger
  name: 'ASV - La soirée'
  stream: orion.logFormatter
  level: 'info'
Meteor.startup ->
  if Meteor.isClient
    appLog.level 'fatal' if IS_MOBILE
