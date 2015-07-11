class @PaymentController extends RouteController

appLog.info 'Adding payment page'
Router.route '/payment',
  controller: PaymentController
  action: -> @render 'payment'

Meteor.methods
  checkPayment: (obj) ->
    check obj, SubscribersSchema
    try
      appLog.info 'Payment by check for subscriber', obj
      throw new Meteor.Error 'payment',
        'Erreur interne, veuillez ré-essayer plus tard'
    catch error
      appLog.warn error, typeof error
      throw new Meteor.Error 'payment',
        'Erreur interne, veuillez ré-essayer plus tard'

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
      form: 'form'
      container: '.card-wrapper'
      messages:
        validDate: 'date\nvalidité'
        monthYear: 'mm/aa'
  # Test cards
  # - visa: 4111111111111111
  # - mastercard: 5555555555554444
  # - maestro: 6759649826438453
  # - amex: 378282246310005
  # - discover: 6011111111111117
  # - visaelectron: 4917300800000000
  # - dinersclub: 30569309025904
  # - unionpay: 6271136264806203568
  # - jcb: 3530111333300000
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
    validateCheck: (e) ->
      e.preventDefault()
      obj = CookieSingleton.get().content()
      Meteor.call 'checkPayment', obj.preSubscriptionValue, (error, result) ->
        # Display an error message
        if error
          appLog.warn 'Set check payment failed', error.reason, error
          return sAlert.error error.reason
        # Go back to subscription screen
        Router.go '/#subscription'
    goBraintree: -> window.open 'https://braintreepayments.com'

if Meteor.isServer
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
