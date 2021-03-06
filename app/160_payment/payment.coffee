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
        validDate: 'Date de\nvalidité'
        monthYear: 'Mois / Année'
      values:
        number: '•••• •••• •••• ••••'
        name: 'NOM COMPLET'
        expiry: '••/••'
        cvc: '•••'
  # Test cards
  # - amex:
  #   - 378282246310005
  #   - 371449635398431
  # - discover:
  #   - 6011111111111117
  # - jcb:
  #   - 3530111333300000
  # - maestro:
  #   - 6304000000000000
  # - mastercard:
  #   - 5555555555554444
  # - visa:
  #   - 4111111111111111
  #   - 4005519200000004
  #   - 4009348888881881
  #   - 4012000033330026
  #   - 4012000077777777
  #   - 4012888888881881
  #   - 4217651111111119
  #   - 4500600000000061
  Template.payment.viewmodel
    isCorrectCookie: -> CookieSingleton.get().isPreSubed()
    paiementInformations: ->
      cookieContent = CookieSingleton.get().content()
      # Benefit from the access to the cookie information for displaying
      #  the easy invitation ID
      @easyInvitationId cookieContent.preSubscriptionValue.easyInvitationId
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
    paymentError: (reason) ->
      appLog.warn reason
      Meteor.setTimeout (=> @validateCardDisabled false), 5000
      sAlert.error reason
    validateCheckDisabled: false
    easyInvitationId: ''
    validateCheck: (e) ->
      e.preventDefault()
      @validateCheckDisabled true
      obj = CookieSingleton.get().content()
      obj.preSubscriptionValue.paymentUserValidated = true
      Meteor.call 'checkPayment', obj.preSubscriptionValue, (error, result) =>
        # Display an error message
        return @paymentError error.reason if error
        # Set user payment validation in cookie for further sessions
        CookieSingleton.get().preSubStore obj.preSubscriptionValue
        # Go back to subscription screen
        Router.go '/#subscription'
    errorText: 'Entrez vos informations de paiements'
    # Debug values
    # number: '378282246310005'
    # name: 'PEM'
    # expiry: '12/15'
    # cvc: '123'
    number: ''
    name: ''
    expiry: ''
    cvc: ''
    changeExpiry: ->
      # Circumvent autofill issue
      str = @expiry()
      if s.contains str, ' / '
        @expiry "#{str.split(' / ')[0]}/"
      # Check if card is properly filled
      @checkCard()
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
      appLog.info 'Creating client and token'
      try
        Meteor.call 'clientToken', client, (error, result) =>
          # Display an error message
          return @paymentError error if error
          appLog.info 'Client created: ', result
          # Creating a customer nonce
          appLog.info 'Creating a Braintree token'
          client = new braintree.api.Client
            clientToken: result.token.clientToken
          tokenParam =
            number: s.replaceAll @number(), ' ', ''
            cardholderName: @name()
            expirationDate: @expiry()
            cvv: @cvc()
            billingAddress: countryCodeAlpha2: 'FR'
          client.tokenizeCard tokenParam, (error, nonce) =>
            return @paymentError error if error
            appLog.info 'Nonce created: ', nonce
            Meteor.call 'cardPayment', result.customer.customer.id, nonce
            , (error, result) =>
              return @paymentError error if error
              appLog.info 'Payment done: ', result
              # Set cookie info
              obj = CookieSingleton.get().content()
              obj.preSubscriptionValue.paymentUserValidated = true
              CookieSingleton.get().preSubStore obj.preSubscriptionValue
              # Reset form
              @reset()
              # Go back to subscription screen
              Router.go '/#subscription'
      catch error
        @paymentError error
    goBraintree: -> window.open 'https://braintreepayments.com'
  , ['validateCheck', 'checkCard', 'changeExpiry', 'validateCard']

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
  if str.length isnt 5
    return 'Entrez la date d\'expiration de votre carte.'
  [strMonth, strYear] = str.split '/'
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
  # Create default values for the Braintree configuration
  if Meteor.isServer
    unless config[confKey]?
      config[confKey] = Meteor.settings.braintree[conf.key]
      changed = true
if Meteor.isServer
  Future = Npm.require 'fibers/future'
  if changed
    appLog.info 'Creating or updating Braintree configuration'
    orion.config.collection.update config._id, $set: config
  Meteor.startup ->
    appLog.info 'Connecting server to Braintree in ',
      Meteor.settings.braintree.accountType, 'mode'
    try
      envType = if Meteor.settings.braintree.accountType is 'sandbox' then \
        Braintree.Environment.Sandbox else Braintree.Environment.Production
      @BrainTreeConnect = BrainTreeConnect
        environment: envType
        merchantId: orion.config.get 'BRAINTREE_MERCHANTID'
        publicKey:  orion.config.get 'BRAINTREE_PUBLICKEY'
        privateKey: orion.config.get 'BRAINTREE_PRIVATEKEY'
    catch error
      throw new Meteor.Error 1001, error.message
  Meteor.methods
    checkPayment: (obj) ->
      appLog.info 'Payment by check'
      try
        check obj, SubscribersSchema
        appLog.info 'Payment by check for subscriber', obj
        sub = Subscribers.findOne email: obj.email
        unless sub?
          throw new Meteor.Error 'payment',
            'Vos données sont corrompues. Effacer vos cookies et ré-essayer.'
        appLog.info 'Updating DB for payment by check'
        Subscribers.update sub._id, $set:
          paymentUserValidated: true
          paymentType: 'check'
          amount: PRICING_TABLE[sub.profile].amount
        appLog.info 'Payment by check done'
      catch error
        appLog.warn error, typeof error
        throw new Meteor.Error 'payment',
          'Vos données sont corrompues. Effacer vos cookies et ré-essayer.'
    clientToken: (client) ->
      appLog.info 'Creating customer on Braintree'
      # Check transimtted data consistency
      try
        check client, SubscribersSchema
        # Check if client is in the database
        appLog.info 'Checking if customer is presubscribed'
        clientDb = Subscribers.findOne email: client.email
        unless clientDb?
          throw new Meteor.Error 'payment', "Unknown client: #{client.email}"
        # Check data consistency
        for k, v of client
          if (clientDb[k] is undefined) or (v isnt clientDb[k])
            unless v is ''
              throw new Meteor.Error 'payment',
                "Consistency #{client.email}, #{k}: #{v}, #{clientDb[k]}"
      catch error
        appLog.warn 'Fraud attempt:', error
        throw new Meteor.Error 'payment',
          'Vos informations de paiement ne sont pas consistantes.'
      appLog.info 'Customer presubscribed, creating token', client
      # Create a Braintree customer
      braintreeCustomer =
        firstName: client.forname
        lastName: client.name
        email: client.email
      # Treat optional informations
      braintreeCustomer = BrainTreeConnect.customer.create braintreeCustomer
      appLog.info 'Updating DB for Braintree customer', braintreeCustomer
      # Create token for customer
      token = BrainTreeConnect.clientToken.generate
        customerId: braintreeCustomer.customer.id
      appLog.info 'Payment token created', token
      Subscribers.update clientDb._id, $set:
        paymentUserValidated: true
        paymentType: 'card'
        braintreeCustomerId: braintreeCustomer.customer.id
        paymentCardToken: token.clientToken
        amount: PRICING_TABLE[clientDb.profile].amount
      appLog.info 'Customer and token created'
      return {
        customer: braintreeCustomer
        token: token
      }
    cardPayment: (customerId, nonce) ->
      appLog.info 'Payment by card'
      # Check if client is in the database
      try
        check customerId, String
        check nonce, String
        appLog.info 'Find client in DB', customerId
        clientDb = Subscribers.findOne braintreeCustomerId: customerId
        unless clientDb?
          throw new Meteor.Error 'payment', 'Client inconnu pour le paiement'
        # Perform the payment
        appLog.info 'Creating a sale transaction', clientDb, nonce
        result = BrainTreeConnect.transaction.sale
          amount: s.numberFormat PRICING_TABLE[clientDb.profile].amount, 2
          paymentMethodNonce: nonce
        appLog.info 'Updating DB for the payment', result
        throw new Meteor.Error 'payment', result.message unless result.success
        Subscribers.update clientDb._id, $set:
          paymentStatus: true
          paymentTransactionId: result.transaction.id
        appLog.info 'Payment request performed'
        return result
      catch error
        appLog.warn 'Fraud attempt:', error.message
        throw new Meteor.Error 'payment',
          'Vos informations de paiement ne sont pas consistantes.'
