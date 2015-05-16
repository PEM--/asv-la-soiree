@srvLog = new Logger 'server'

Meteor.startup ->
  # Check if at least one users has been created.
  if Meteor.users.find().count() is 0
    srvLog.info 'No user found'
    for admin in Meteor.settings.admin
      srvLog.info "Creating #{admin.name}"
      adminId = Accounts.createUser
        email: admin.email
        password: admin.password
        profile:
          name: admin.name
