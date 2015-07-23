if Meteor.isServer
  # Subscribers with user-friendly invitation number
  Migrations.add
    version: 1
    up: ->
      # Subscriber migration
      appLog.info 'Data migration v2: Subscribers: Data migration'
      subs = Subscribers.find().fetch()
      for sub, idx in subs
        sub.easyInvitationId = 100 + idx
        Subscribers.update sub._id, $set: easyInvitationId: sub.easyInvitationId
        appLog.info 'Subscribers: Updating', sub.email,
          'with easyInvitationId', sub.easyInvitationId
  Meteor.startup ->
    # Current migration value
    appLog.info 'Migration version is', Migrations.getVersion()
    # Launch data migration
    Migrations.migrateTo 'latest'
