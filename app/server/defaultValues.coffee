@srvLog = new Logger 'server'

Meteor.startup ->
  # Check if Meteor is laouchned with settings.
  if Meteor.settings.admins is undefined
    err = 'Lauch Meteor with settings: meteor --settings settings.json'
    srvLog.error err
    return throw new Meteor.Error 'setup', err
  # Check if at least one users has been created.
  if Meteor.users.find().count() is 0
    srvLog.info 'No user found'
    for admin in Meteor.settings.admins
      srvLog.info "Creating #{admin.name}"
      adminId = Accounts.createUser
        email: admin.email
        password: admin.password
        profile:
          name: admin.name
