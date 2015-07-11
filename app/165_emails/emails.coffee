# Mandrill account in the CMS secret informations
orion.config.add 'MANDRILL_HOST', 'mandrill',
  type: String
  label: 'Adresse du serveur d\'envoi de mail (MANDRILL_HOST)'
orion.config.add 'MANDRILL_PORT', 'mandrill',
  type: Number
  label: 'Port du serveur d\'envoi de mail (MANDRILL_PORT)'
orion.config.add 'MANDRILL_SMTP_USERNAME', 'mandrill',
  type: String
  label: 'Email du détenteur du compte (MANDRILL_SMTP_USERNAME)'
orion.config.add 'MANDRILL_API_KEY', 'mandrill',
  type: String
  label: 'Identifiant de l\'application (MANDRILL_API_KEY)'

# Create default values for the Mandrill configuration
if Meteor.isServer
  config = orion.config.collection.findOne()
  changed = false
  unless config.MANDRILL_HOST?
    config.MANDRILL_HOST = Meteor.settings.mandrill.host
    changed = true
  unless config.MANDRILL_PORT?
    config.MANDRILL_PORT = Meteor.settings.mandrill.port
    changed = true
  unless config.MANDRILL_SMTP_USERNAME?
    config.MANDRILL_SMTP_USERNAME = Meteor.settings.mandrill.smtp_username
    changed = true
  unless config.MANDRILL_API_KEY?
    config.MANDRILL_API_KEY = Meteor.settings.mandrill.api_key
    changed = true
  if changed
    appLog.info 'Creating or updating Mandrill configuration'
    orion.config.collection.update config._id,
      $set:
        MANDRILL_HOST: config.MANDRILL_HOST
        MANDRILL_PORT: config.MANDRILL_PORT
        MANDRILL_SMTP_USERNAME: config.MANDRILL_SMTP_USERNAME
        MANDRILL_API_KEY: config.MANDRILL_API_KEY
