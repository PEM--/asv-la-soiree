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

# Simple pages for Home, EULA, Cookies
Pages = new orion.collection 'pages',
  singularName: 'page',
  pluralName: 'pages'
  tabular:
    columns: [
      { data: 'title', title: 'Titre'  }
      orion.attributeColumn 'froala', 'body', 'Contenu'
    ]
Pages.attachSchema new SimpleSchema
  title: type: String
  body: orion.attribute 'froala', label: 'Contenu'
  createdBy: orion.attribute 'createdBy'
