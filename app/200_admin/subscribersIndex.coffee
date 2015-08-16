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
        RouterLayer.go path
    'click button.import-csv': (e, t) ->
      # Prevent further actions
      csvButton = t.$ 'button.import-csv'
      csvButton.addClass 'disabled'
      subscription = Meteor.subscribe 'allSubscribers',
        onReady: ->
          data = Subscribers.find({},{name: 1, forname: 1, _id: 0}).fetch()
          # Create the header
          csv = (_.keys data[0]).join ';'
          for sub in data
            csv += '\n' + (_.values sub).join ';'
          # Automatic download of the CSV as a Blob file
          blobDownload csv, 'subscribers.csv', 'text/csv'
          # Allow further extracts
          csvButton.removeClass 'disabled'
        onError: (err) ->
          sAlert.warning 'Récupération des inscrits impossible'
          appLog.warn 'CSV subscription failed', err
          # Allow further extracts
          csvButton.removeClass 'disabled'
    'click button.import-sage': (e, t) ->
      # Prevent further actions
      sageButton = t.$ 'button.import-sage'
      sageButton.addClass 'disabled'
      subscription = Meteor.subscribe 'allSubscribers',
        onReady: ->
          data = Subscribers.find(
            {paymentStatus: true},
            {fields: {name: 1, forname: 1, createdAt: 1, amount: 1}}
          ).fetch()
          fileContent = ''
          # Populate SAGE file with all the subscribers that are in paid status
          version = orion.dictionary.get 'sage.version', 0
          for sub in data
            fullName = "#{sub.name} #{sub.forname}"
            sageUnitary = new SageExporter fullName, sub.createdAt, sub.amount
            sageUnitary.formatAll version
            fileContent = fileContent.concat sageUnitary.toString(), '\n'
          fileName = "sage-#{s.lpad version, 3, '0'}.txt"
          # Automatic download of the SAGE file as a Blob file
          blobDownload fileContent, fileName, 'text/plain'
          # Allow further extracts
          sageButton.removeClass 'disabled'
        onError: (err) ->
          sAlert.warning 'Récupération des inscrits impossible'
          appLog.warn 'SAGE subscription failed', err
          # Allow further extracts
          sageButton.removeClass 'disabled'

  Template.subscribersIndex.helpers
    showTable: ->
      Template.instance().subscribersIndex_showTable.get()

if Meteor.isServer
  Meteor.publish 'allSubscribers', -> Subscribers.find()
