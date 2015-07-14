class @PaymentController extends RouteController

appLog.info 'Adding payment page'
Router.route '/payment',
  controller: PaymentController
  action: -> @render 'payment'

if Meteor.isClient
  Template.payment.onCreated ->
    appLog.info 'Creating payment screen'
    # Check if pre-subscription has been done
    unless CookieSingleton.get().isPreSubed()
      # Automatically go to subscription screen if no information found
      sAlert.error 'Nous n\'avons pas retrouvé votre inscription.'
      Meteor.setTimeout ->
        Router.go '/#subscription'
      , 3000
  Template.payment.onRendered ->
    # Card size is adjusted depending on width
    viewportSize = Math.min rwindow.$width(), rwindow.$height()
    cardWidth = if viewportSize < 400 then 200 else 300
    # Create card for displaying user's entries
    @card = new Card
      width: cardWidth
      form: 'form.card'
      container: '.card-wrapper'
      messages:
        validDate: 'date\nvalidité'
        monthYear: 'mm/aa'
  # Test cards
  # - visa:         4111111111111111
  # - mastercard:   5555555555554444
  # - maestro:      6759649826438453
  # - amex:         378282246310005
  # - discover:     6011111111111117
  # - visaelectron: 4917300800000000
  # - dinersclub:   30569309025904
  # - unionpay:     6271136264806203568
  # - jcb:          3530111333300000
  Template.payment.viewmodel
    isCorrectCookie: -> CookieSingleton.get().isPreSubed()
    paiementInformations: ->
      cookieContent = CookieSingleton.get().content()
      pricing = PRICING_TABLE[cookieContent.preSubscriptionValue.profile]
      #0123456789012345678901234567890123456789
      dashLine = s.repeat '-', 40
      '          FACTURE (FACTICE)             \n' +
      dashLine + s.repeat('\n', 2) +
      'ASV, LA SOIREE                          \n' +
      s.rpad(pricing.tag, 34, ' ') +
        numeral(pricing.amount).format('0,0.00$') +
        s.repeat('\n', 2) +
      dashLine
    paymentType: ''
    isPaymentTypeCheck: -> @paymentType() is 'check'
    isPaymentTypeCard: -> @paymentType() is 'card'
    validateCheckDisabled: false
    validateCheck: (e) ->
      e.preventDefault()
      @validateCheckDisabled true
      obj = CookieSingleton.get().content()
      Meteor.call 'checkPayment', obj.preSubscriptionValue, (error, result) =>
        # Display an error message
        if error
          appLog.warn 'Set check payment failed', error.reason, error
          Meteor.setTimeout =>
            @validateCheckDisabled false
          , 5000
          return sAlert.error error.reason
        # Go back to subscription screen
        Router.go '/#subscription'
    errorText: 'Entrez vos informations de paiements'
    number: ''
    name: ''
    expiry: ''
    cvc: ''
    checkCard: ->
      @validateCardDisabled true
      # Check card number
      res = checkCardNumber @number()
      return (@errorText res) unless res is ''
      # Check name
      res = checkCardName @name()
      return (@errorText res) unless res is ''
      # Check expiry
      res = checkCardExpiry @expiry()
      return (@errorText res) unless res is ''
      # CVC
      res = checkCardCvc @cvc()
      return (@errorText res) unless res is ''
      # All informations seem OK, allow payment validation
      @errorText ''
      @validateCardDisabled false
    validateCardDisabled: true
    validateCard: (e) ->
      e.preventDefault()
      @validateCardDisabled true
      client = CookieSingleton.get().content().preSubscriptionValue
      card =
        number: @number()
        name: @name()
        expiry: @expiry()
        cvc: @cvc()
      Meteor.call 'clientToken', client, card, (error, result) =>
        # Display an error message
        if error
          appLog.warn 'Set check payment failed', error.reason, error
          Meteor.setTimeout =>
            @validateCheckDisabled false
          , 5000
          return sAlert.error error.reason
        console.log 'Token: ', result

    goBraintree: -> window.open 'https://braintreepayments.com'
  , ['validateCheck', 'checkCard', 'validateCard']

checkCardNumber = (str) ->
  if str.length > 19
    return 'Votre n° de carte est trop long.'
  if str.length < 14
    return 'Votre n° de carte est incomplet.'
  if _.isNaN s.toNumber s.replaceAll str, ' ', ''
    return 'Votre n° de carte ne peut contenir de lettres.'
  return ''

checkCardName = (str) ->
  if str.length < 2
    return 'Entrez le nom inscrit sur votre carte.'
  if str.length > 26
    return 'Entrez uniquement le nom inscrit sur votre carte.'
  return ''

checkCardExpiry = (str) ->
  if str.length isnt 7
    return 'Entrez la date d\'expiration de votre carte.'
  [strMonth, strYear] = str.split ' / '
  month = s.toNumber strMonth
  if (strMonth.length isnt 2) or ( _.isNaN month) or
      (month < 1) or (month > 12)
    return 'Le mois d\'expiration est inconsistant.'
  if (_.isUndefined strYear) or (strYear.length isnt 2)
    return 'L\'année d\'expiration est inconsistante.'
  year = s.toNumber strYear
  currentYear = moment(new Date).year() - 2000
  if (_.isNaN year) or (year < currentYear)
    return 'L\'année d\'expiration est inconsistante.'
  return ''

checkCardCvc = (str) ->
  if ((str.length isnt 3) and (str.length isnt 4)) or
      (_.isNaN s.toNumber str)
    return 'Le cryptogramme doit comporter 3 ou 4 chiffres.'
  return ''

BRAINTREE_CONFS = [
  {
    key: 'merchantId', type: String
    label: 'Identifiant du marchand'
  }
  {
    key: 'publicKey', type: String
    label: 'Clef publique'
  }
  {
    key: 'privateKey', type: String
    label: 'Clef privée'
  }
]

# Create configuration for Braintree (available in Orion's configuration)
if Meteor.isServer
  config = orion.config.collection.findOne()
  changed = false
for conf in BRAINTREE_CONFS
  # Braintree account in the CMS secret informations
  confKey = "BRAINTREE_#{conf.key.toUpperCase()}"
  orion.config.add confKey, 'braintree',
    type: conf.type
    label: "#{conf.label} (#{confKey})"
  # Create default values for the Mandrill configuration
  if Meteor.isServer
    unless config[confKey]?
      config[confKey] = Meteor.settings.braintree[conf.key]
      changed = true
if Meteor.isServer
  if changed
    appLog.info 'Creating or updating Braintree configuration'
    orion.config.collection.update config._id, $set: config
  Meteor.startup ->
    appLog.info 'Connecting server to Braintree'
    try
      @BrainTreeConnect = BrainTreeConnect
        environment: Braintree.Environment.Sandbox
        merchantId: Meteor.settings.braintree.merchantId
        publicKey:  Meteor.settings.braintree.publicKey
        privateKey: Meteor.settings.braintree.privateKey
        # return BrainTreeConnect.customer.create(config);
    catch error
      throw new Meteor.Error 1001, error.message
  Meteor.methods
    checkPayment: (obj) ->
      check obj, SubscribersSchema
      appLog.info 'Payment by check for subscriber', obj
      sub = Subscribers.findOne email: obj.email
      unless sub?
        throw new Meteor.Error 'payment',
          'Vos données sont corrompues. Effacer vos cookies et ré-essayer'
      try
        Subscribers.update sub._id, $set: paymentType: 'check'
      catch error
        appLog.warn error, typeof error
        throw new Meteor.Error 'payment',
          'Erreur interne, veuillez ré-essayer plus tard'
    clientToken: (client, card) ->
      # Check transimtted data consistency
      check client, SubscribersSchema
      check card, Object
      if (card.number is undefined) or (card.name is undefined) or
          (card.expiry is undefined) or (card.cvc is undefined) or
          (not _.isString card.number) or (not _.isString card.name) or
          (not _.isString card.expiry) or (not _.isString card.cvc)
        throw new Meteor.Error 'payment',
          'Vos informations de paiement ne sont pas consistantes.'
      res = checkCardNumber card.name
      throw new Meteor.Error 'payment', res unless res is ''
      res = checkCardName card.number
      throw new Meteor.Error 'payment', res unless res is ''
      res = checkCardExpiry card.expiry
      throw new Meteor.Error 'payment', res unless res is ''
      res = checkCardCvc card.cvc
      throw new Meteor.Error 'payment', res unless res is ''
      appLog.info 'Creating token for payment by card for subscriber', client
      # Create a Braintree customer
      braintreeCustomer =
        firstName: client.forname
        lastName: client.name
        email: client.email
        countryCodeAlpha2: 'FR'
        cardholderName: '???'
      # Treat optional informations
      unless client.phone is ''
        _.extend braintreeCustomer, phone: client.phone

      BrainTreeConnect.customer.create braintreeCustomer
      , (err, result) ->
        return {
          titi: 'toto'
          tutu: 200
        }
