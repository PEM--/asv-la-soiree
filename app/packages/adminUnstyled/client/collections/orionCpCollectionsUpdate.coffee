Template.orionCpCollectionsUpdate.onCreated ->
  orionLog.info 'orionCpCollectionsUpdate created'

Template.orionCpCollectionsUpdate.events
  'click .save-btn': ->
    $('#orionCpCollectionsUpdateForm').submit()

AutoForm.addHooks 'orionCpCollectionsUpdateForm',
  onSuccess: -> Router.go this.collection.indexPath()
