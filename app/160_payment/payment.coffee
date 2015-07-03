class @PaymentController extends RouteController

appLog.info 'Adding payment page'
Router.route '/payment',
  controller: PaymentController
  action: -> @render 'payment'

if Meteor.isClient
  Template.payment.onCreated ->
    appLog.info 'Creating payment screen'
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
    # - ASV diplômée 2014-2015 = 20 €
    # - ASV en formation congrès = 35 €
    # - Tarifs autres (accompagnant, véto…) = 50 €
    paiementInformations:
      #0123456789012345678901234567890123456789
      "          FACTURE (FACTICE)\n" +
      "          -----------------\n\n" +
      "ASV, LA SOIREE                    20,00€\n"
