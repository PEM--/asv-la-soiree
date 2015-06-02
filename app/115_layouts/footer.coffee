if Meteor.isClient
  Template.footer.onRendered ->
    console.log '****'
    console.log 'Footer', @data
  Template.footer.events
    'click a.internal': (e, t) ->
      e.preventDefault()
      goNextRoute e.target.href
