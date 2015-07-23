# Analytics
orion.dictionary.addDefinition 'google-ua', 'analytics',
  type: String, label: 'Google UA'
# Cookie information
orion.dictionary.addDefinition 'message', 'cookie',
  type: String, label: 'Message d\'information'
  autoform: type: 'textarea'
# Stop subscription
orion.dictionary.addDefinition 'endsubscription', 'settings',
  type: Boolean, label: 'Fermer les inscriptions'

# OrionJS options
# Avoid registration without invitation
Options.set 'forbidClientAccountCreation', true
# Default users are not admin but inherit from the public role
Options.set 'defaultRoles', ['public']
# Set siteName
Options.set 'siteName', orion.dictionary.get 'site.title'
# Set homePath
Options.set 'homePath', Meteor.settings.public.proxy.url
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
  # Values injected in the head of the initial HTML payload
  @headValues =
    cookie:
      message: "En poursuivant votre navigation sur ce site, \
        vous acceptez l'utilisation des cookies pour vous \
        proposer des services et offres adaptés."
  _.extend headValues, seoHeadValues()
  _.extend headValues, socialValues()
  # There's only one item in the dictionnary which serves
  #  as an object containing all properties for the site.
  dicId = (orion.dictionary.findOne())._id
  orion.dictionary.update dicId, {'$set': headValues} , (err) ->
    return appLog.error "Dictionnary update failed: #{err}" if err
    appLog.info 'Default site description created or updated'
    orion.dictionary.update dicId,
      '$set': analytics:
        'google-ua': Meteor.settings.public.ga.id
    , (err) ->
      return appLog.error "Dictionnary update failed: #{err}" if err
      appLog.info 'Default site analytics created or updated'
