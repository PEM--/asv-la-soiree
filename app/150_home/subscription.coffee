if Meteor.isClient
  Template.subscription.viewmodel
    name: ''
    forname: ''
    email: ''
    phone: ''
    contactType: 'mail'
    phoneRequired: -> @contactType() isnt 'phone'
    disabledSubmit: -> true

# Subscribers
@Subscribers = new orion.collection 'subscribers',
  singularName: 'inscrit'
  pluralName: 'inscrits'
  title: 'Inscrits'
  tabular:
    columns: [
      { data: 'name', title: 'Nom'  }
      { data: 'forname', title: 'Prénom'  }
      { data: 'email', title: 'Email'  }
    ]

@SubscribersSchema = new SimpleSchema
  name:
    type: String
    label: 'Nom'
    min: 2
    max: 128
  forname:
    type: String
    label: 'Prénom'
    min: 2
    max: 128
  email:
    type: String
    label: 'E-mail'
    min: 5
    max: 256
  createdAt: orion.attribute 'createdAt'

Subscribers.attachSchema SubscribersSchema
