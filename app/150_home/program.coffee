if Meteor.isClient
  Template.program.viewmodel
    goProgram: -> Router.go '/#subscription'
