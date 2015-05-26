# Dictionnary
# Site wide values
orion.dictionary.addDefinition 'title', 'site',
  type: String, label: 'Titre'
orion.dictionary.addDefinition 'description', 'site',
  type: String, label: 'Description', autoform: type: 'textarea'
# Analytics
orion.dictionary.addDefinition 'google-ua', 'analytics',
  type: String, label: 'Google UA'

# OrionJS options
# Avoid registration without invitation
Options.set 'forbidClientAccountCreation', true
# Default users are not admin but inherit from the public role
Options.set 'defaultRoles', ['public']
# Set siteName
Options.set 'siteName', orion.dictionary.get 'site.title'
# Set homePath
Options.set 'homePath', __meteor_runtime_config__.ROOT_URL

# Set default template for Autoform
if Meteor.isClient
  AutoForm.setDefaultTemplate 'plain'

if Meteor.isServer
  Meteor.startup ->
    # Check if site description is available.
    if orion.dictionary.find({site:{'$exists':true}}).count() is 0
      srvLog.info 'No site description'
      # There's only one item in the dictionnary which serves
      #  as an object containing all properties for the site.
      dicId = (orion.dictionary.findOne())._id
      orion.dictionary.update dicId,
        '$set': site:
          title: 'ASV, la soirée'
          description: """
            Une super soirée pour le
            congrès des ASV, les auxiliaires vétérinaires.
          """
      , (err) ->
        return srvLog.error "Dictionnary update failed: #{err}" if err
        srvLog.info 'Default site description created'
    # Check if Google analytics is available.
    if orion.dictionary.find({analytics:{'$exists':true}}).count() is 0
      srvLog.info 'No Google analytics key found'
      dicId = (orion.dictionary.findOne())._id
      orion.dictionary.update dicId,
        '$set': analytics:
          'google-ua': Meteor.settings.public.ga.id
      , (err) ->
        return srvLog.error "Dictionnary update failed: #{err}" if err
        srvLog.info 'Default site description created'
