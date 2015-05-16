# OrionJS options
# Avoid registration without invitation
Options.set 'forbidClientAccountCreation', true

# Default users are not admin but inherit from the public role
Options.set 'defaultRoles', ['public']

# Dictionnary
# Site wide values
orion.dictionary.addDefinition 'title', 'site',
  type: String, label: 'Titre'
orion.dictionary.addDefinition 'description', 'site',
  type: String, label: 'Description', autoform: type: 'textarea'

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

# Simple pages for Home, EULA, Cookies
Pages = new orion.collection 'pages',
  singularName: 'page',
  pluralName: 'pages'
  tabular:
    columns: [
      { data: 'title', title: 'Titre'  }
      orion.attributeColumn 'file', 'image', 'Image'
      orion.attributeColumn 'froala', 'body', 'Contenu'
    ]
Pages.attachSchema new SimpleSchema
  title: type: String
  image: orion.attribute 'file', label: 'Image', optional: true
  body: orion.attribute 'froala', label: 'Contenu'
  createdBy: orion.attribute 'createdBy'
