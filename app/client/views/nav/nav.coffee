Template.nav.onRendered ->
  # Prevent basic link behavior for adding an in between transition
  #  before activating the routing.
  (@$ 'a').on 'click', (e) ->
    e.preventDefault()
    goNextRoute e.target.pathname

Template.nav.helpers
  links: -> navLinks
  activeRoute: ->
    curSlug = getSlug()
    if @slug is curSlug then 'active' else ''

Template.nav.events
  'click .svg-logo-container': (e, t) -> goNextRoute '/'
  'click .hamburger-button': (e, t) -> (t.$ e.target).toggleClass 'open'
