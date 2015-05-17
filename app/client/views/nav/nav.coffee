Template.nav.onRendered ->
  # Store router container as a variable shared on the template
  @$routerContainer = $('.router-container')
  # Prevent basic link behavior for adding an in between transition
  #  before activating the routing.
  $('a').on 'click', (e) =>
    e.preventDefault()
    @$routerContainer.css 'opacity', 0
    .on TRANSITION_END_EVENT, =>
      # Transition when fade out animation is done
      Router.go e.target.pathname
      @$routerContainer.css 'opacity', 1
      @$routerContainer.off TRANSITION_END_EVENT

Template.nav.helpers
  links: -> navLinks
  activeRoute: -> if @slug is Router.current().url then 'active' else ''

Template.nav.events
  'click .svg-logo-container': (e, t) ->
    # Intercept routing with a fade in animation
    t.$routerContainer.css 'opacity', 0
    .on TRANSITION_END_EVENT, ->
      Router.go '/'
      t.$routerContainer.css 'opacity', 1
      t.$routerContainer.off TRANSITION_END_EVENT
