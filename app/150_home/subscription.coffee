if Meteor.isClient
  Template.subscription.viewmodel
    profile: ''
    name: ''
    forname: ''
    email: ''
    contactType: 'mail'
    phone: ''
    errorText: ''
    phoneRequired: -> @contactType() isnt 'phone'
    disabledSubmit: ->
      obj =
        profile: @profile()
        name: @name()
        forname: @forname()
        email: @email()
        contactType: @contactType()
        phone: @phone()
      appLog.info 'Subscription values: ', obj
      try
        check obj, SubscribersSchema
      catch error
        text = ((error.message).split 'Match error: ')[1]
        # Reformat error message if necessary
        text = switch text
          when ' n\'est pas une valeur autorisée'
            'Choisissez votre profil'
          when  'N° de téléphone ne satisfait pas l\'expression régulière', \
                'N° de téléphone doit être supérieur ou égal à [min]'
            'Le n° de téléphone doit être du type: 0612345678'
          else text
        @errorText text
        appLog.info 'Subscription values: ', error.message, @errorText()
        return true
      # Reset error text when field seems OK
      @errorText ''
      return false

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

# Set only the fields required in the UI
@SubscribersSchema = new SimpleSchema
  profile:
    type: String
    label: 'Profil'
    allowedValues: ['asv_graduate', 'asv_serving', 'attendant']
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
    optional: true
    # min: 10
    # max: 10
    custom: ->
      regEx = /(0|\\+33|0033)[1-9][0-9]{8}/
      appLog.info 'Custom check', @value.length, @field('contactType').value
      if @field('contactType').value is 'phone'
        if @value.length is 0
          return 'required'
        unless @value.match /(0|\\+33|0033)[1-9][0-9]{8}/
          return 'minNumber'

# Add the fields for the DB and the admin UI
SubscribersFullSchema = new SimpleSchema [
  SubscribersSchema
  {
    createdAt: orion.attribute 'createdAt'
  }
]

Subscribers.attachSchema SubscribersFullSchema
