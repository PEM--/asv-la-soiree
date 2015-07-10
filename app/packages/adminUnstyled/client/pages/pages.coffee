Template.orionCpPagesIndex.onCreated ->
  orionLog.info 'orionCpPagesIndex created'

Template.orionCpPagesCreate.onCreated ->
  orionLog.info 'orionCpPagesCreate created'

Template.orionCpPagesUpdate.onCreated ->
  orionLog.info 'orionCpPagesUpdate created'

Template.orionCpPagesDelete.onCreated ->
  orionLog.info 'orionCpPagesDelete created'

Template.orionCpPagesIndex.events
  'click tr': (event) ->
    return unless $(event.target).is('td')
    dataTable = $(event.target).closest('table').DataTable()
    rowData = dataTable.row(event.currentTarget).data()
    (Router.go 'pages.update', rowData) if rowData
