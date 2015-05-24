Template.orionCpLayout.onCreated ->
  orionLog.info 'orionCpLayout created'

Template.orionCpOutAdminLayout.onCreated ->
  orionLog.info 'orionCpOutAdminLayout created'

Template.orionCpLayout.events
  'click aside.toggled': (e, t) -> (t.$ 'aside').removeClass 'toggled'
  'click .menu-toggle': (e, t) -> (t.$ 'aside').toggleClass 'toggled'

Template.orionCpTabs.helpers items: -> @

Template.orionCpTabs.events 'click a': -> @onClick()
