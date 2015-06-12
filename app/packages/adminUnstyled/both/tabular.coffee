orion.collections.onCreated ->
  self = @
  # if the collection doesn't has the tabular option, nothing to do here!
  return unless _.has @, 'tabular'
  Tracker.autorun ->
    currentLang = i18n.getLanguage()
    appLog.info 'Current language', currentLang
    tabularOptions = _.extend
      name: "tabular_#{self.name}"
      collection: self
      columns: [{data: '_id', title: 'ID'}]
      selector: (userId) ->
        selectors = Roles.helper userId, "collections.#{self.name}.indexFilter"
        { $or: selectors }
      language:
        search: i18n 'tabular.search'
        info: i18n 'tabular.info'
        infoEmpty: i18n 'tabular.infoEmpty'
        lengthMenu: i18n 'tabular.lengthMenu'
        emptyTable: i18n 'tabular.emptyTable'
        paginate:
          first: i18n 'tabular.paginate.first'
          previous: i18n 'tabular.paginate.previous'
          next: i18n 'tabular.paginate.next'
          last: i18n 'tabular.paginate.last'
    , self.tabular
    tabularOptions.columns.map (column) ->
      if _.isFunction column.title
        column.langTitle = column.title
      if _.isFunction column.langTitle
        column.title = column.langTitle()
      column
    self.tabularTable = new Tabular.Table tabularOptions
    console.log 'Tabular', self.tabularTable, tabularOptions
