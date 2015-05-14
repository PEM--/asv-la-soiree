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

# Simple pages for EULA, Cookies
# orion.pages.addTemplate
#   template: 'pageStaticContent'
#   layout: 'layout'
#   description: 'Contenus statique'
# ,
#   content: orion.attribute 'summernote',
#     label: 'Contenu'
