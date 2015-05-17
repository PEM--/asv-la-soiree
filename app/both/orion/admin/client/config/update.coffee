Template.orionCpConfigUpdate.helpers
  getDataForTabs: ->
    categories = orion.config.getCategories()
    categories.map (category) ->
      title: category
      onClick: -> Session.set 'configUpdateCurrentCategory', category
      class: ->
        if Session.get('configUpdateCurrentCategory') is category \
          then 'btn-default disabled' else 'btn-primary'
