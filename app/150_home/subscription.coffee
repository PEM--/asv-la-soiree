if Meteor.isClient
  Template.subscription.viewmodel
    name: ''
    forname: ''
    email: ''
    phone: ''
    contactType: 'mail'
    phoneRequired: -> @contactType() isnt 'phone'
    disabledSubmit: -> true
