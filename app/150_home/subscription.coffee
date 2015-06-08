if Meteor.isClient
  Template.subscription.viewmodel
    isCookieAccepted: -> CookieSingleton.get().isAccepted()
    profile: ''
    enabledAsvPromo: -> @asvPromoDisabled not (@profile() is 'asv_graduate')
    enabledAttendant: -> @attendantDisabled not (@profile() is 'attendant')
    asvPromoDisabled: true
    attendant: ''
    attendantDisabled: true
    attendantTypes: -> SubscribersSchema.getAllowedValuesForKey 'attendant'
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
        text = (error.message.split 'Match error: ')[1]
        # Reformat error message if necessary
        appLog.info 'Subscription not filled: ',text
        @setErrorText text
        return true
      # Reset error text when field seems OK
      @errorText ''
      return false
    setErrorText: (text) ->
      text = switch text
        when ' n\'est pas une valeur autorisée'
          'Choisissez votre profil'
        when  'N° de téléphone ne satisfait pas l\'expression régulière', \
              'N° de téléphone doit être supérieur ou égal à [min]'
          'Le n° de téléphone doit être du type: 0612345678'
        when  'Internal server error'
          'Nous n\'étions pas prêts. Pourriez-vous ré-essayer plus tard ?'
        else text
      @errorText text
    subscribe: (e) ->
      obj =
        profile: @profile()
        name: @name()
        forname: @forname()
        email: @email()
        contactType: @contactType()
        phone: @phone()
      appLog.info 'Subscription attempt', obj
      unless Match.test obj, SubscribersSchema
        appLog.warn 'Subscription failed, match is incorrect'
        @setErrorText 'Veuillez vérifier vos informations'
      else
        Meteor.call 'presubscribe', obj, (error, result) =>
          # Display an error message and do not store the presubscription cookie
          if error and error.error isnt 'presubscribe.already'
            appLog.warn 'Subscription failed', error.reason, error
            return @setErrorText error.reason
          if error?.error is 'presubscribe.already'
            appLog.warn 'Subscription already done'
            sAlert.warning error.reason
          # Store the subscription so that it cannot be done twice
          CookieSingleton.get().preSubStore obj

if Meteor.isServer
  Meteor.methods
    presubscribe: (obj) ->
      check obj, SubscribersSchema
      try
        Subscribers.insert _.extend obj, createdAt: new Date
        appLog.info 'Inserted new subscriber', obj
      catch error
        appLog.warn error, typeof error
        if ((JSON.stringify error).search 'duplicate') isnt -1
          throw new Meteor.Error 'presubscribe.already','Vous êtes déjà inscrit'
        else
          throw new Meteor.Error 'presubscribe', 'Internal server error'

# Subscribers
@Subscribers = new orion.collection 'subscribers',
  singularName: 'inscrit'
  pluralName: 'inscrits'
  title: 'Inscrits'
  link: title: 'Inscrits'
  tabular:
    columns: [
      { data: 'name', title: 'Nom' }
      { data: 'forname', title: 'Prénom' }
      {
        data: 'createdAt', title: 'Inscrit le'
        render: (val, type, doc) ->
          if val instanceof Date
            return moment(val).calendar()
          return 'Jamais inscrit'
      }
    ]

# Set only the fields required in the UI
@SubscribersSchema = new SimpleSchema
  profile:
    type: String
    label: 'Profil'
    allowedValues: ['asv_graduate', 'asv_serving', 'attendant']
  asvPromo:
    type: String
    label: 'N° de promo'
    max: 128
    optional: true
    custom: ->
      if @field('profile').value is 'asv_graduate'
        if @value.length is 0
          return 'required'
  attendant:
    type: String
    optional: true
    allowedValues: ['Employeur', 'Conjoint', 'Labos', 'Autre']
    custom: ->
      if @field('profile').value is 'attendant'
        if @value.length is 0
          return 'required'
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
    custom: ->
      regEx = /(0|\\+33|0033)[1-9][0-9]{8}/
      if @field('contactType').value is 'phone'
        if @value.length is 0
          return 'required'
        unless @value.match /(0|\\+33|0033)[1-9][0-9]{8}/
          return 'minNumber'

# Add the fields for the DB and the admin UI
SubscribersFullSchema = new SimpleSchema [
  SubscribersSchema
  { createdAt: orion.attribute 'createdAt' }
]

Subscribers.attachSchema SubscribersFullSchema
