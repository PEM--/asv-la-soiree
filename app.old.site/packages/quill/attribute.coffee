orion.attributes.registerAttribute 'quill',
  template: 'orionAttributesQuill'
  previewTemplate: 'orionAttributesQuillColumn'
  getSchema: (options) ->
    type: String
  valueOut: ->
    @find('.quill').code()
