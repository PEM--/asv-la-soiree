@quill = {}

Template.test.onRendered =>
  @quill = new Quill '.quill-editor'
  @quill.addModule 'toolbar', container: '.quill-toolbar'
