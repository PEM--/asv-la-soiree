MANDRILL_CONFS = [
  {
    key: 'host', type: String
    label: 'Adresse du serveur d\'envoi de mail'
  }
  {
    key: 'port', type: Number
    label: 'Port du serveur d\'envoi de mail'
  }
  {
    key: 'smtp_username', type: String
    label: 'Email du détenteur du compte'
  }
  {
    key: 'api_key', type: String
    label: 'Identifiant de l\'application'
  }
  {
    key: 'sender_email', type: String
    label: 'Email de réponse'
  }
  {
    key: 'sender_name', type: String
    label: 'Nom de l\'auteur de l\'email de réponse'
  }
  {
    key: 'template_slug', type: String
    label: 'Slug du template d\'email'
  }
  {
    key: 'template_slug', type: String
    label: 'Slug du template d\'email'
  }
  {
    key: 'email_subject', type: String
    label: 'Sujet de l\'email'
  }
]

if Meteor.isServer
  config = orion.config.collection.findOne()
  changed = false
for conf in MANDRILL_CONFS
  # Mandrill account in the CMS secret informations
  confKey = "MANDRILL_#{conf.key.toUpperCase()}"
  orion.config.add confKey, 'mandrill',
    type: conf.type
    label: "#{conf.label} (MANDRILL_#{confKey})"
  # Create default values for the Mandrill configuration
  if Meteor.isServer
    unless config[confKey]?
      config[confKey] = Meteor.settings.mandrill[conf.key]
      changed = true
if Meteor.isServer
  if changed
    appLog.info 'Creating or updating Mandrill configuration'
    orion.config.collection.update config._id, $set: config
