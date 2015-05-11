# OrionJS options
# Avoid registration without invitation
Options.set 'forbidClientAccountCreation', true

# Default users are not admin but inherit from the public role
Options.set 'defaultRoles', ['public']

# Dictionnary
# Site wide values
orion.dictionary.addDefinition 'title', 'site', type: String, label: 'Titre'
