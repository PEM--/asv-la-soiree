ReactiveTemplates.set 'collections.subscribers.index', 'subscribersIndex'

if Meteor.isClient
  Template.subscribersIndex.onCreated ->
    appLog.info 'subscribersIndex created'
    @subscribersIndex_showTable = new ReactiveVar
    @subscribersIndex_showTable.set false

  Template.subscribersIndex.onRendered ->
    @autorun =>
      Template.currentData()
      @subscribersIndex_showTable.set false
      Meteor.defer =>
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
      # Prevent further actions
      (t.$ 'button.import-csv').addClass 'disabled'
      subscription = Meteor.subscribe 'allSubscribers',
        onReady: ->
          data = Subscribers.find({},{name: 1, forname: 1, _id: 0}).fetch()
          # Create the header
          csv = (_.keys data[0]).join ';'
          for sub, idx in data
            csv += '\n' + (_.values sub).join ';'
          # Automatic download of the CSV as a Blob file
          blobDownload csv, 'subscribers.csv', 'text/csv'
          # Allow further extracts
          ($ 'button.import-csv').removeClass 'disabled'
        onError: (err) ->
          sAlert.warning 'Récupération des inscrits impossible'
          appLog.warn 'CSV subscription failed', err
          # Allow further extracts
          ($ 'button.import-csv').removeClass 'disabled'

  Template.subscribersIndex.helpers
    showTable: ->
      Template.instance().subscribersIndex_showTable.get()

if Meteor.isServer
  Meteor.publish 'allSubscribers', -> Subscribers.find()
