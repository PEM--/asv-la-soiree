orion.collections.onCreated ->
  # if the collection doesn't has the tabular option, nothing to do here!
  return unless _.has @, 'tabular'
  Tracker.autorun =>
    # Use reactivity to capture language changes
    currentLang = i18n.getLanguage()
    tabularOptions = _.extend
      name: "tabular_#{@name}"
      collection: @
      columns: [{data: '_id', title: 'ID'}]
      selector: (userId) =>
        selectors = Roles.helper userId, "collections.#{@name}.indexFilter"
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
    , @tabular
    tabularOptions.columns.map (column) ->
      if _.isFunction column.title
        column.langTitle = column.title
      if _.isFunction column.langTitle
        column.title = column.langTitle()
      column
    @tabularTable = new Tabular.Table tabularOptions
