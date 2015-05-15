@quill = {}

Template.test.onRendered =>
  @quill = new Quill '.quill-editor',
    theme: 'snow'
    modules:
      toolbar: container: '.quill-toolbar'
      'link-tooltip': true
      #'image-tooltip': true

Template.test.helpers
  colors: -> [
    'rgb(0, 0, 0)'
    'rgb(230, 0, 0)'
    'rgb(255, 153, 0)'
    'rgb(255, 255, 0)'
    'rgb(0, 138, 0)'
    'rgb(0, 102, 204)'
    'rgb(153, 51, 255)'
  ]
