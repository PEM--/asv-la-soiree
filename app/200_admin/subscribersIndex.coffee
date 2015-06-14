ReactiveTemplates.set 'collections.subscribers.index', 'subscribersIndex'

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
      collection = Template.currentData().collection
      dataTable = $(e.target).closest('table').DataTable()
      rowData = dataTable.row(e.currentTarget).data()
      if rowData?.canShowUpdate()
        path = collection.updatePath rowData
        Router.go path
    'click button.import-csv': (e, t) ->
      # @TODO Missing subscribe
      data = Subscribers.find({},{name: 1, forname: 1, _id: 0}).fetch()
      # Create the header
      csv = (_.keys data[0]).join ';'
      for sub, idx in data
        csv += '\n' + (_.values sub).join ';'
      # Automatic download of the CSV as a Blob file
      blobDownload csv, 'subscribers.csv', 'text/csv'

  Template.subscribersIndex.helpers
    showTable: ->
      Template.instance().subscribersIndex_showTable.get()
