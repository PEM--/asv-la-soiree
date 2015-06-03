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
      { data: 'name', title: 'Nom' }
      { data: 'forname', title: 'Prénom' }
      { data: 'createdAt', title: 'Inscrit le' }
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
    regEx: SimpleSchema.RegEx.Email
    unique: true
    min: 5
    max: 256
  contactType:
    type: String
    allowedValues: ['mail', 'phone']
  phone:
    type: String
    label: 'N° de téléphone'
    min: 10
    max: 10
    optional: true
    custom: ->
      if @value.length is 0 and  @field('contactType') is 'phone'
        return 'required'
  createdAt: orion.attribute 'createdAt'

Subscribers.attachSchema SubscribersSchema
