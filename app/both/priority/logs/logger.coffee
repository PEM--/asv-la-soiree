# Create the logging system for the client and the server
if Meteor.isServer
  @appLog = new Logger 'server'
if Meteor.iClient
  @appLog = new Logger 'client'
