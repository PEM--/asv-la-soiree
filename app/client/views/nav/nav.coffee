Template.nav.onRendered ->
  # Prevent basic link behavior for adding an in between transition
  #  before activating the routing.
  (@$ 'a').on 'click', (e) ->
    e.preventDefault()
    goNextRoute e.target.pathname
  # Automatically set opacity of the main menu depending on route.
  @autorun  ->
    # Only the opacity to 1 on slug route except home
    # @NOTE This fixes a bug on Safari iOS and Chrome Android
    curSlug = getSlug()
    t = _.pluck navLinks, 'slug'
    if curSlug in _.pluck navLinks, 'slug'
      ($ 'nav').css 'opacity', 1

Template.nav.helpers
  links: -> navLinks
  activeRoute: ->
    curSlug = getSlug()
    if @slug is curSlug then 'active' else ''

Template.nav.events
  'click .svg-logo-container': (e, t) -> goNextRoute '/'
