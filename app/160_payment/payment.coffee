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
      # Meteor.setTimeout ->
      #   Router.go '/#subscription'
      # , 2000
  Template.payment.onRendered ->
    console.log @
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
  Template.payment.viewmodel
    isCorrectCookie: -> CookieSingleton.get().isPreSubed()
    # - ASV diplômée 2014-2015 = 20 €
    # - ASV en formation congrès = 35 €
    # - Tarifs autres (accompagnant, véto…) = 50 €
    paiementInformations:
      #0123456789012345678901234567890123456789
      "          FACTURE (FACTICE)             \n" +
      "----------------------------------------\n\n" +
      "ASV, LA SOIREE                          \n" +
      "Tarif autres                      50,00€\n\n" +
      "----------------------------------------"


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
