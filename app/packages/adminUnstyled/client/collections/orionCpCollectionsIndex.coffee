Template.orionCpCollectionsIndex.onCreated ->
  orion.log.info 'orionCpCollectionsIndex created'

Template.orionCpCollectionsIndex.events
  'click tr': (event) ->
    return unless $(event.target).is('td')
    dataTable = $(event.target).closest('table').DataTable()
    rowData = dataTable.row(event.currentTarget).data()
    collection = rowData._collection()
    if rowData
      if rowData.canShowUpdate()
        path = collection.updatePath rowData
        RouterLayer.go path

Template.orionCpCollectionsIndex.onRendered ->
  @autorun ->
    RouterLayer.isActiveRoute ''
    Session.set 'orionCpCollectionsIndex_showTable', false
    Meteor.defer -> Session.set 'orionCpCollectionsIndex_showTable', true

Template.orionCpCollectionsIndex.helpers
  showTable: -> Session.get 'orionCpCollectionsIndex_showTable'
