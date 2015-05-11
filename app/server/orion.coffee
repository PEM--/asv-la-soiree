# OrionJS options
# Avoid registration without invitation
Options.set 'forbidClientAccountCreation', true

# Default users are not admin but inherit from the public role
Options.set 'defaultRoles', ['public']
