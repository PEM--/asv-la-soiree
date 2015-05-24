Template.orionCpDictionaryUpdate.onCreated ->
  console.log 'orionCpDictionaryUpdate created'

Template.orionCpDictionaryUpdate.helpers
  getDataForTabs: ->
    categories = orion.dictionary.availableCategories()
    categories.map (category) ->
      title: category
      onClick: -> Session.set 'dictionaryUpdateCurrentCategory', category
      class: ->
        if Session.get('dictionaryUpdateCurrentCategory') == category \
          then 'btn-default disabled' else 'btn-primary'
