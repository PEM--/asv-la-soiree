Template.nav.helpers
  links: -> navLinks
  activeRoute: -> if @slug is Router.current().url then 'active' else ''


Template.nav.events
  'click .svg-logo-container': (e, t) -> Router.go '/'
