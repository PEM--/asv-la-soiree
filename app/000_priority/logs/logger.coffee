# Create the logging system for the client and the server
@appLog = new Logger if Meteor.isServer then 'server' else 'client'
