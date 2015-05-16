ReactiveTemplates.onRendered 'attribute.quill', ->
  @subscribe 'quillImages'
  Session.set 'orionQuillIsUploading', false
  @quill = new Quill '.quill-editor',
    theme: 'snow'
    modules:
      toolbar: container: '.quill-toolbar'
      'link-tooltip': true
      'image-tooltip': true

  # element = @$('.quill')
  # element.quill
  #   height: 300
  #   onImageUpload: (files, editor, $editable) ->
  #     upload = orion.filesystem.upload
  #       fileList: files
  #       name: files[0].name
  #       uploader: 'quill'
  #     Session.set 'orionQuillIsUploading', true
  #     Session.set 'orionQuillProgress', 0
  #     Tracker.autorun ->
  #       if upload.ready()
  #         if upload.error
  #           console.log upload.error
  #           alert upload.error.reason
  #         else
  #           editor.insertImage $editable, upload.url
  #         Session.set 'orionQuillIsUploading', false
  #       return
  #     Tracker.autorun ->
  #       Session.set 'orionQuillProgress', upload.progress()
  #       return
  #     return
  # element.code @data.value

ReactiveTemplates.helpers 'attribute.quill',
  isUploading: ->
    Session.get 'orionQuillIsUploading'
  progress: ->
    Session.get 'orionQuillProgress'
  colors: -> [
    'rgb(0, 0, 0)'
    'rgb(230, 0, 0)'
    'rgb(255, 153, 0)'
    'rgb(255, 255, 0)'
    'rgb(0, 138, 0)'
    'rgb(0, 102, 204)'
    'rgb(153, 51, 255)'
  ]

ReactiveTemplates.helpers 'attributePreview.quill', preview: ->
  value = @value
  tmp = document.createElement('DIV')
  content = value.replace(/<(?:.|\n)*?>/gm, ' ')
  if content.length > 50
    content = content.substring(0, 47).trim() + '...'
  content
