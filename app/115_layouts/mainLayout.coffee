if Meteor.isClient
  Template.mainLayout.onRendered ->
    @$('.main-container:not([data-role=\'spinner\'])')
      .css 'opacity', 1
