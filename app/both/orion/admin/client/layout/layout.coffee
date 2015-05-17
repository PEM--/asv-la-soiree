Template.orionCpLayout.events
  'click .orion-Cp-admin.toggled': ->
    $('.orion-Cp-admin').removeClass 'toggled'
    $('html,body').removeClass 'no-overflow'
  'click .menu-toggle': ->
    $('.orion-Cp-admin').toggleClass 'toggled'
    $('html,body').toggleClass 'no-overflow'
Template.orionCpTabs.helpers
  items: -> @
Template.orionCpTabs.events
  'click a': -> @onClick()
