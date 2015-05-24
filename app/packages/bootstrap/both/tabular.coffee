orion.collections.onCreated ->
  self = this
  # if the collection doesn't has the tabular option, nothing to do here!
  unless _.has this, 'tabular'
    console.log 'No tabular collection'
    return
  tabularOptions = _.extend
    name: "tabular_#{@name}"
    collection: @
    columns: [data: '_id', title: 'ID']
    selector: (userId) ->
      selectors = Roles.helper userId, "collection.#{self.name}.indexFilter"
      { $or: selectors }
  , @tabular
  @tabularTable = new (Tabular.Table)(tabularOptions)
