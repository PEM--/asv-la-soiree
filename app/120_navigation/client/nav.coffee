# Model for the main menu
@mainMenuModel = new ViewModel
  white: false
  menuContentOpened: false
  opacity: 1
  show: ->  @opacity 1
  hide: -> @opacity 0
  height: ->
    # TODO Fix this hideous hack
    if @templateInstance is undefined then 52 \
    else (@templateInstance.$ 'nav').height()
  goHome: ->
    @menuContentOpened false
    goNextRoute '/'
  hamburger: (e) -> @menuContentOpened not @menuContentOpened()
  # @NOTE The pages are requested again for taking use of a reative cursor
  links: -> Pages.find {$or: [{display: 1}, {display: 2}]}, sort: order: 1

# Subscribe to pages
Template.nav.onCreated ->
  appLog.info 'Creating main menu'
  # Expose the ViewModel's helpers to Blaze
  @vm = mainMenuModel
  @vm.addHelper 'links', @
  appLog.info 'Property set?'

Template.nav.onRendered ->
  appLog.info 'Rendering main menu'
  # Bind ViewModel to template
  mainMenuModel.bind @

# ViewModel for the menu's items
Template.navItem.viewmodel (data) ->
  id: data._id
  page: -> Pages.findOne @id()
  slug: -> @page().slug
  name: -> @page().title
  changeRoute: (e) ->
    e.preventDefault()
    @parent().menuContentOpened false
    goNextRoute @slug()
  #activeRoute: -> if @slug() is getSlug() then 'active' else ''
