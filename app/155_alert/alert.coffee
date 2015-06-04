if Meteor.isClient
  @initialConnection = true
  Meteor.startup ->
    # Configure sAlert
    sAlert.config effect: 'jelly'
    # Alert user when womething bad happens on the server
    Tracker.autorun ->
      status = Meteor.status()
      appLog.info 'Connexion au serveur modifiée', status, initialConnection
      switch status.status
        when 'connected'
          if window.initialConnection
            window.initialConnection = false
          else
            sAlert.info 'Connecté au serveur'
        when 'connecting' then sAlert.warning 'En cours de connexion au serveur'
        when 'failed' then sAlert.danger 'Déconnecté du serveur'
        when 'waiting' then sAlert.warning 'Reconnexion au serveur'
        when 'offline' then sAlert.warning 'Déconnecté d\'Internet'
