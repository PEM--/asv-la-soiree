# Dictionnary
# Site wide values
orion.dictionary.addDefinition 'title', 'site',
  type: String, label: 'Titre'
orion.dictionary.addDefinition 'description', 'site',
  type: String, label: 'Description', autoform: type: 'textarea'
orion.dictionary.addDefinition 'lastModified', 'site',
  type: Date, label: 'Dernière modification (utile pour indiquer au moteur de \
    recherche que de nouvelles informations sont disponibles)', \
    autoform: type: 'date'
# Analytics
orion.dictionary.addDefinition 'google-ua', 'analytics',
  type: String, label: 'Google UA'
# Cookie information
orion.dictionary.addDefinition 'message', 'cookie',
  type: String, label: 'Message d\'information'
  autoform: type: 'textarea'

# OrionJS options
# Avoid registration without invitation
Options.set 'forbidClientAccountCreation', true
# Default users are not admin but inherit from the public role
Options.set 'defaultRoles', ['public']
# Set siteName
Options.set 'siteName', orion.dictionary.get 'site.title'
# Set homePath
Options.set 'homePath', __meteor_runtime_config__.ROOT_URL
Options.arrayPush 'defaultRoles', 'public'
Options.set 'profileSchema',
  picture: orion.attribute 'file',
    label: 'Picture'
    optional: true
,
  name: type: String

# Set default template for Autoform
if Meteor.isClient
  AutoForm.setDefaultTemplate 'plain'

if Meteor.isServer
  # Check if site description is available.
  if orion.dictionary.find({site:{'$exists':true}}).count() is 0
    appLog.info 'No site description'
    # There's only one item in the dictionnary which serves
    #  as an object containing all properties for the site.
    dicId = (orion.dictionary.findOne())._id
    orion.dictionary.update dicId,
      '$set':
        site:
          title: 'ASV, la soirée'
          description: 'Une super soirée pour le congrès des ASV, \
            les auxiliaires vétérinaires.'
          lastModified: new Date()
        cookie:
          message: "En poursuivant votre navigation sur ce site, \
            vous acceptez l'utilisation des cookies pour vous \
            proposer des services et offres adaptés."
    , (err) ->
      return appLog.error "Dictionnary update failed: #{err}" if err
      appLog.info 'Default site description created'
  # Check if Google analytics is available.
  if orion.dictionary.find({analytics:{'$exists':true}}).count() is 0
    appLog.info 'No Google analytics key found'
    dicId = (orion.dictionary.findOne())._id
    orion.dictionary.update dicId,
      '$set': analytics:
        'google-ua': Meteor.settings.public.ga.id
    , (err) ->
      return appLog.error "Dictionnary update failed: #{err}" if err
      appLog.info 'Default site description created'
