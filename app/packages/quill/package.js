Package.describe({
  name: 'orionjs:quill',
  summary: 'Quill editor for orion',
  version: '1.0.1',
  git: 'https://github.com/orionjs/orion'
});

Package.onUse(function(api) {
  api.versionsFrom('1.1.0.2');
  api.use([
    'jquery',
    'coffeescript',
    'orionjs:base@1.0.0',
    'orionjs:attributes@1.0.0',
    'orionjs:filesystem@1.0.0',
    'mquandalle:jade@0.4.3',
    'fortawesome:fontawesome@4.3.0'
  ]);

  // api.imply([
  //   'summernote:standalone',
  //   ]);

  api.addFiles([
    'attribute.coffee',
  ]);

  api.addFiles([
    'quill.jade',
    'quill.coffee',
    'styles/base.styl',
    'styles/image-tooltip.styl',
    'styles/link-tooltip.styl',
    'styles/multi-cursor.styl',
    'styles/paste-manager.styl',
    'styles/quill.styl',
    'styles/toolbar.styl',
    'styles/tooltip.styl',
    'bower_components/quill/dist/quill.min.js'
  ], 'client');
});
