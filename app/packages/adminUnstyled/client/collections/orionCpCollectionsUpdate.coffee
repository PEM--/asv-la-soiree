Template.orionCpCollectionsUpdate.onCreated ->
  orion.log.info 'orionCpCollectionsUpdate created'

Template.orionCpCollectionsUpdate.events
  'click .save-btn': ->
    $('#orionCpCollectionsUpdateForm').submit()

AutoForm.addHooks 'orionCpCollectionsUpdateForm',
  onSuccess: -> RouterLayer.go this.collection.indexPath()
