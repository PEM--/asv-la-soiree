Template.orionCpCollectionsCreate.onCreated ->
  orion.log.info 'orionCpCollectionsCreate created'

Template.orionCpCollectionsCreate.events
  'click .create-btn': ->
    $('#orionCpCollectionsCreateForm').submit()

AutoForm.addHooks 'orionCpCollectionsCreateForm',
  onSuccess: -> Router.go @collection.indexPath()
