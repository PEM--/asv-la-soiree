Template.orionCpCollectionsCreate.onCreated ->
  orion.log.info 'orionCpCollectionsCreate created'

Template.orionCpCollectionsCreate.events
  'click .create-btn': ->
    $('#orionCpCollectionsCreateForm').submit()

AutoForm.addHooks 'orionCpCollectionsCreateForm',
  onSuccess: -> RouterLayer.go @collection.indexPath()
