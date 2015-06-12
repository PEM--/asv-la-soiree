ReactiveTemplates.set 'collections.subscribers.index', \
  'subscribersIndex'

if Meteor.isClient
  Template.subscribersIndex.onCreated ->
    orionLog.info 'subscribersIndex created'

  Template.subscribersIndex.onCreated ->
    @subscribersIndex_showTable = new ReactiveVar
    @subscribersIndex_showTable.set false

  Template.subscribersIndex.onRendered ->
    @autorun =>
      Template.currentData()
      #Session.set 'subscribersIndex_showTable', false
      @subscribersIndex_showTable.set false
      Meteor.defer =>
        #Session.set 'subscribersIndex_showTable', true
        @subscribersIndex_showTable.set true

  Template.subscribersIndex.events
    'click tr': (e, t) ->
      return unless $(event.target).is 'td'
      console.log 'template', t
      collection = Template.currentData().collection
      dataTable = $(e.target).closest('table').DataTable()
      rowData = dataTable.row(e.currentTarget).data()
      if rowData?.canShowUpdate()
        path = collection.updatePath rowData
        Router.go path
    'click button.import-csv': (e, t) ->
      console.log 'Importing CSV', e, t

  Template.subscribersIndex.helpers
    showTable: ->
      Template.instance().subscribersIndex_showTable.get()
