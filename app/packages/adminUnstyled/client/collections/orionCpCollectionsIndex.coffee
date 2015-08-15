Template.orionCpCollectionsIndex.onCreated ->
  orion.log.info 'orionCpCollectionsIndex created'

Template.orionCpCollectionsIndex.events
  'click tr': (event) ->
    return unless $(event.target).is('td')
    collection = Template.currentData().collection
    dataTable = $(event.target).closest('table').DataTable()
    rowData = dataTable.row(event.currentTarget).data()
    if rowData
      if rowData.canShowUpdate()
        path = collection.updatePath rowData
        Router.go path

Template.orionCpCollectionsIndex.onRendered ->
  @autorun ->
    Template.currentData()
    Session.set 'orionCpCollectionsIndex_showTable', false
    Meteor.defer -> Session.set 'orionCpCollectionsIndex_showTable', true

Template.orionCpCollectionsIndex.helpers
  showTable: -> Session.get 'orionCpCollectionsIndex_showTable'
