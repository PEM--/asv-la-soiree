Template.orionCpPagesIndex.onCreated ->
  orion.log.info 'orionCpPagesIndex created'

Template.orionCpPagesCreate.onCreated ->
  orion.log.info 'orionCpPagesCreate created'

Template.orionCpPagesUpdate.onCreated ->
  orion.log.info 'orionCpPagesUpdate created'

Template.orionCpPagesDelete.onCreated ->
  orion.log.info 'orionCpPagesDelete created'

Template.orionCpPagesIndex.events
  'click tr': (event) ->
    return unless $(event.target).is('td')
    dataTable = $(event.target).closest('table').DataTable()
    rowData = dataTable.row(event.currentTarget).data()
    (RouterLayer.go 'pages.update', rowData) if rowData
