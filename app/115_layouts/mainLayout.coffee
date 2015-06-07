if Meteor.isClient
  Template.mainLayout.onRendered ->
    @$('.main-container:not([data-role=\'spinner\'])')
      .css 'opacity', 1
  Template.mainLayout.transition = ->
    appLog.error 'Momentum, mainLayout?'
    return (from, to, element) ->
      appLog.error 'Momentum, mainLayout, inner?'
      return 'fade'
