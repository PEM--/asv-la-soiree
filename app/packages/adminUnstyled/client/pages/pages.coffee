Template.orionCpPagesIndex.onCreated ->
  console.log 'orionCpPagesIndex created'

Template.orionCpPagesCreate.onCreated ->
  console.log 'orionCpPagesCreate created'

Template.orionCpPagesUpdate.onCreated ->
  console.log 'orionCpPagesUpdate created'

Template.orionCpPagesDelete.onCreated ->
  console.log 'orionCpPagesDelete created'

Template.orionCpPagesIndex.events
  'click tr': (event) ->
    return unless $(event.target).is('td')
    dataTable = $(event.target).closest('table').DataTable()
    rowData = dataTable.row(event.currentTarget).data()
    Router.go 'pages.update', rowData if rowData
