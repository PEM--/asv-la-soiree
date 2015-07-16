if Meteor.isClient
  Template.subscription.onRendered ->
    @viewmodel.isPresubscribed CookieSingleton.get().isPreSubed()

  Template.subscription.viewmodel
    isCookieAccepted: -> CookieSingleton.get().isAccepted()
    isPresubscribed: true
    isErrorDisplayed: ->
      unless (@profile().length isnt 0) or (@name().length isnt 0) or
          (@forname().length isnt 0) or (@email().length isnt 0)
        return false
      return true
    profile: ''
    asvPromo: ''
    asvPromoDisabled: true
    enabledAsvPromo: -> @asvPromoDisabled not (@profile() is 'asv_graduate')
    attendant: 'Choisissez :'
    attendantDisabled: true
    enabledAttendant: -> @attendantDisabled not (@profile() is 'attendant')
    attendantTypes: -> SubscribersSchema.getAllowedValuesForKey 'attendant'
    name: ''
    forname: ''
    email: ''
    contactType: 'mail'
    phone: ''
    newsletter: false
    errorText: ''
    phoneRequired: -> @contactType() isnt 'phone'
    priceOpacity: -> if @profile() is '' then 0 else 1
    priceTag: ->
      return '' if @profile() is ''
      PRICING_TABLE[@profile()].tag + ' : ' +
        '<span class=\'amount\'>' +
          numeral(PRICING_TABLE[@profile()].amount).format('0,0.00$') +
        '</span>'
    disabledSubmit: ->
      obj =
        profile: @profile()
        asvPromo: @asvPromo()
        attendant: @attendant()
        name: @name()
        forname: @forname()
        email: @email()
        contactType: @contactType()
        phone: @phone()
        newsletter: @newsletter()
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
        asvPromo: @asvPromo()
        attendant: @attendant()
        name: @name()
        forname: @forname()
        email: @email()
        contactType: @contactType()
        phone: @phone()
        newsletter: @newsletter()
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
          if error and error.error is 'presubscribe.already'
            appLog.warn 'Subscription already done'
            sAlert.warning error.reason
          # Store the subscription so that it cannot be done twice
          CookieSingleton.get().preSubStore obj
          # Reset the form and mask pre-subscription
          @reset()
          @isPresubscribed true
          # Go to payment screen
          Router.go 'payment'

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
      { data: 'paymentTransactionId', title: 'N° de paiement' }
    ]

SimpleSchema.messages
  asvPromoInvalid:'N° de promo requis ou invalide (ex. "VAE-2015" ou "ASV-300")'
  attendantInvalid: 'Type d\'accompagnant invalide'

# Set only the fields required in the UI
@SubscribersSchema = new SimpleSchema
  profile:
    type: String
    label: 'Profil'
    allowedValues: ['asv_graduate', 'asv_serving', 'attendant']
    autoform:
      type: 'select'
      options: -> [
        {value: 'asv_graduate', label: 'ASV Diplômé GIPSA en 2014 ou 2015'}
        {value: 'asv_serving', label: 'ASV Auxiliaire Vétérinaire'}
        {value: 'attendant', label: 'Autres (accompagnants, vétos, ...)'}
      ]
  asvPromo:
    type: String
    label: 'N° de promo'
    max: 128
    optional: true
    custom: ->
      if (@field('profile').value is 'asv_graduate') and (
        (@value.length is 0) or (@value.length < 7) or (@value.length > 8))
        return 'asvPromoInvalid'
      return null
  attendant:
    type: String
    label: 'Autres'
    optional: true
    allowedValues: [
      'Choisissez :'
      'Vétérinaire'
      'Accompagnant'
      'Labos'
      'Autres'
    ]
    custom: ->
      if (@field('profile').value is 'attendant') and
          (@value not in @definition.allowedValues.slice 1)
        return 'attendantInvalid'
      return null
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
      return null
  newsletter:
    type: Boolean
    label: 'Inscrit à la newsletter'
    optional: true
    defaultValue: false

# Set fields for payment validation
@PaymentsSchema = new SimpleSchema
  paymentStatus:
    type: Boolean
    defaultValue: false
    label: 'Statut du paiement'
  paymentType:
    type: String
    defaultValue: 'card'
    allowedValues: ['card', 'check']
    autoform:
      type: 'select'
      options: -> [
        {value: 'card', label: 'Carte bancaire'}
        {value: 'check', label: 'Chèque' }
      ]
    label: 'Type de paiement'
  paymentCardToken:
    type: String
    optional: true
    label: 'Token de transaction de paiement par carte'
  paymentTransactionId:
    type: String
    optional: true
    label: 'Identifiant de transaction de paiement'
  amount:
    type: Number
    defaultValue: 0
    label: 'Montant du paiement'
  subscriptionValidated:
    type: Boolean
    defaultValue: false
    label: 'Inscription validée'

ASV_PRICING_TABLE = amount: 35, tag: 'Tarif ASV'
@PRICING_TABLE =
  asv_graduate: ASV_PRICING_TABLE
  asv_serving: ASV_PRICING_TABLE
  attendant: amount: 45, tag: 'Tarif accompagnant'

# Add the fields for the DB and the admin UI
SubscribersFullSchema = new SimpleSchema [
  SubscribersSchema
  { createdAt: orion.attribute 'createdAt' }
  PaymentsSchema
]

Subscribers.attachSchema SubscribersFullSchema
