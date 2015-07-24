if Meteor.isClient
  Template.subscription.onRendered ->
    # If subscrption are closed, prevent any form access or display of
    #  the end subscription message.
    @autorun =>
      endSubscription = orion.dictionary.get 'settings.endSubscription'
      unless endSubscription is ''
        @viewmodel.reset()
        @viewmodel.errorText ''
        @viewmodel.isPaymentUserValidated false
        @viewmodel.endSubscription true
      else
        # Depending on user's state (subscribed but no payment or payment
        #  validated), fill the initial values of the form.
        @viewmodel.endSubscription false
        cookie = CookieSingleton.get()
        if cookie.isPaymentUserValidated()
          @viewmodel.isPaymentUserValidated true
        else
          @viewmodel.isPaymentUserValidated false
          if cookie.isPreSubed()
            cookieCnt = cookie.content()
            @viewmodel.profile cookieCnt.preSubscriptionValue.profile
            if cookieCnt.preSubscriptionValue.asvPromo
              @viewmodel.asvPromo cookieCnt.preSubscriptionValue.asvPromo
              @viewmodel.enableAsvPromo true
            if cookieCnt.preSubscriptionValue.attendant?
              @viewmodel.attendant cookieCnt.preSubscriptionValue.attendant
              @viewmodel.attendantDisabled false
            if cookieCnt.preSubscriptionValue.animalOwnership
              @viewmodel.animalOwnership \
                cookieCnt.preSubscriptionValue.animalOwnership
            switch cookieCnt.preSubscriptionValue.profile
              when 'asv_graduate', 'asv_serving'
                @viewmodel.animalOwnershipEnabled true
            @viewmodel.name cookieCnt.preSubscriptionValue.name
            @viewmodel.forname cookieCnt.preSubscriptionValue.forname
            @viewmodel.email cookieCnt.preSubscriptionValue.email
            @viewmodel.contactType cookieCnt.preSubscriptionValue.contactType
            if cookieCnt.preSubscriptionValue.phone?
              @viewmodel.phone cookieCnt.preSubscriptionValue.phone
            if cookieCnt.preSubscriptionValue.newsletter?
              @viewmodel.newsletter cookieCnt.preSubscriptionValue.newsletter
      # Avoid error text when screen is created
      Meteor.defer =>
        @viewmodel.errorText ''

  Template.subscription.viewmodel
    isCookieAccepted: -> CookieSingleton.get().isAccepted()
    isPaymentUserValidated: true
    endSubscription: false
    profile: ''
    asvPromo: ''
    asvPromoDisabled: true
    enableAsvPromo: -> @asvPromoDisabled not (@profile() is 'asv_graduate')
    attendant: 'Choisissez :'
    attendantDisabled: true
    enableAttendant: -> @attendantDisabled not (@profile() is 'attendant')
    attendantTypes: -> SubscribersSchema.getAllowedValuesForKey 'attendant'
    animalOwnershipEnabled: false
    animalOwnershipTypes: ->
      SubscribersSchema.getAllowedValuesForKey 'animalOwnership'
    enableAnimalOwnership: ->
      @animalOwnershipEnabled switch @profile()
        when 'asv_graduate', 'asv_serving' then true
        else false
    animalOwnership: 'Aucun'
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
    disableSubmit: ->
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
        animalOwnership: @animalOwnership()
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
          console.log '*** presubscribe', error, result
          # Display an error message and do not store the presubscription cookie
          if error and error.error isnt 'presubscribe.already'
            appLog.warn 'Subscription failed', error.reason, error
            return @setErrorText error.reason
          if error and error.error is 'presubscribe.already'
            appLog.warn 'Subscription already done', error
            # Get the easyInvitationId from the error's details
            obj.easyInvitationId = error.reason
          else
            # Get easy invitation ID from result of the server call
            obj.easyInvitationId = result
          # Store the subscription so that it cannot be done twice
          CookieSingleton.get().preSubStore obj
          # Reset the form and mask pre-subscription
          @reset()
          # Go to payment screen
          Router.go 'payment'

Meteor.methods
  presubscribe: (obj) ->
    try
      check obj, SubscribersSchema
      easyInvitationId = 100 + Subscribers.find().count()
      Subscribers.insert _.extend obj,
        createdAt: new Date
        easyInvitationId: easyInvitationId
      appLog.info 'Inserted new subscriber', obj
      return easyInvitationId
    catch error
      appLog.warn error, typeof error
      if ((JSON.stringify error).search 'duplicate') isnt -1
        sub = Subscribers.findOne email: obj.email
        throw new Meteor.Error 'presubscribe.already', sub.easyInvitationId
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
      { data: 'easyInvitationId', title: 'N° d\'inscription' }
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
  animalOwnership:
    type: String
    label: 'Type d\'animal'
    optional: true
    allowedValues: [
      'Aucun'
      'Chien'
      'Chat'
      'NAC'
      'Autres'
    ]
    defaultValue: 'Aucun'
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
  paymentUserValidated:
    type: Boolean
    label: 'Paiement validé par le client'
    optional: true
    defaultValue: false
  easyInvitationId:
    type: Number
    label: 'N° d\'inscription simplifié'
    min: 100
    optional: true
    autoValue: ->
      if @insert
        return 100 + Subscribers.find().count()

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
  braintreeCustomerId:
    type: String
    optional: true
    label: 'Identifiant du client sur Braintree'
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
