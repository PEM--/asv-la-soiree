if Meteor.isClient
  Template.footer.onCreated ->
    appLog.info 'Footer created'
    @subscribe 'basicpages'

  # ViewModel for the footer
  Template.footer.viewmodel
    links: ->
      BasicPages.find {$or: [{display: 1}, {display: 3}]}, sort: order: 1
  , 'links'

  # ViewModel for the footer's items
  Template.footerItem.viewmodel (data) ->
    id: data._id
    page: -> BasicPages.findOne @id()
    slug: -> @page().slug
    name: -> @page().title
    changeRoute: (e) ->
      e.preventDefault()
      Router.go @slug()
