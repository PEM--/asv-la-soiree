orion.collections.onCreated ->
  self = this
  # if the collection doesn't has the tabular option, nothing to do here!
  unless _.has self, 'tabular'
    orionLog.info 'No tabular collection'
    return
  tabularOptions = _.extend
    name: "tabular_#{self.name}"
    collection: self
    columns: [data: '_id', title: 'ID']
    selector: (userId) ->
      selectors = Roles.helper userId, "collection.#{self.name}.indexFilter"
      { $or: selectors }
    language:
      search: i18n 'tabular.search'
      info: i18n 'tabular.info'
      infoEmpty: i18n 'tabular.infoEmpty'
      emptyTable: i18n 'tabular.emptyTable'
      paginate:
        first: i18n 'tabular.paginate.first'
        previous: i18n 'tabular.paginate.previous'
        next: i18n 'tabular.paginate.next'
        last: i18n 'tabular.paginate.last'
  , @tabular
  @tabularTable = new (Tabular.Table)(tabularOptions)

  Tracker.autorun ->
    tabularOptions.columns.map (column) ->
      if _.isFunction column.title
        column.langTitle = column.title
      if _.isFunction column.langTitle
        column.title = column.langTitle()
      column
    self.tabularTable = new Tabular.Table tabularOptions
