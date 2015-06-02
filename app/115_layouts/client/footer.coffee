Template.footer.onCreated ->
  appLog.log 'Footer created'
  @subscribe 'pages'

# ViewModel for the footer
Template.footer.viewmodel
  links: ->
    Pages.find {$or: [{display: 1}, {display: 3}]}, sort: order: 1
, 'links'

# ViewModel for the footer's items
Template.footerItem.viewmodel (data) ->
  id: data._id
  page: -> Pages.findOne @id()
  slug: -> @page().slug
  name: -> @page().title
  changeRoute: (e) ->
    e.preventDefault()
    goNextRoute @slug()
  #activeRoute: -> if @slug() is getSlug() then 'active' else ''
