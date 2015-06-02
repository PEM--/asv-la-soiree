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
  , @tabular
  @tabularTable = new (Tabular.Table)(tabularOptions)
