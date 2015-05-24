Template.orionCpCollectionsIndex.onCreated ->
  orionLog.info 'orionCpCollectionsIndex created'

Template.orionCpCollectionsIndex.onRendered ->
  @autorun ->
    Template.currentData()
    Session.set 'orionCpCollectionsIndex_showTable', false
    Meteor.defer -> Session.set 'orionCpCollectionsIndex_showTable', true

Template.orionCpCollectionsIndex.events
  'click tr': (event) ->
    return unless $(event.target).is('td')
    collection = Template.currentData().collection
    dataTable = $(event.target).closest('table').DataTable()
    rowData = dataTable.row(event.currentTarget).data()
    if rowData
      if rowData.canShowUpdate()
        path = collection.updatePath(rowData)
        Router.go path

Template.orionCpCollectionsIndex.helpers
  showTable: ->
    Session.get 'orionCpCollectionsIndex_showTable'

Template.orionCpCollectionsCreate.onCreated ->
  orionLog.info 'orionCpCollectionsCreate created'

Template.orionCpCollectionsCreate.events
  'click .create-btn': ->
    $('#orionCpCollectionsCreateForm').submit()

AutoForm.addHooks 'orionCpCollectionsCreateForm',
  onSuccess: -> Router.go @collection.indexPath()

Template.orionCpCollectionsUpdate.onCreated ->
  orionLog.info 'orionCpCollectionsUpdate created'

Template.orionCpCollectionsUpdate.events
  'click .save-btn': ->
    $('#orionCpCollectionsUpdateForm').submit()

AutoForm.addHooks 'orionCpCollectionsUpdateForm',
  onSuccess: -> Router.go this.collection.indexPath()

Template.orionCpCollectionsDelete.onCreated ->
  orionLog.info 'orionCpCollectionsDelete created'
