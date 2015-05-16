@srvLog = new Logger 'server'

Meteor.startup ->
  # Check if at least one users has been created.
  if Meteor.users.find().count() is 0
    srvLog.info 'No user found'
