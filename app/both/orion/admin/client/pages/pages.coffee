Template.orionCpPagesIndex.events
  'click tr': (event) ->
    return unless $(event.target).is('td')
    dataTable = $(event.target).closest('table').DataTable()
    rowData = dataTable.row(event.currentTarget).data()
    Router.go 'pages.update', rowData if rowData
