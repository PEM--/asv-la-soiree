if Meteor.isClient
  Template.layout.onRendered ->
    @$('.main-container:not([data-role=\'spinner\'])')
      .css 'opacity', 1
