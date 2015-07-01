class @PaymentController extends RouteController

appLog.info 'Adding payment page'
Router.route '/payment',
  controller: PaymentController
  action: -> @render 'payment'

if Meteor.isClient
  Template.payment.onCreated ->
    appLog.info 'Creating payment screen'
  Template.payment.onRendered ->
    @autorun =>
      console.log 'Autorun', @
      # Card size is adjusted depending on width
      cardWidth = if rwindow.$width() < 400 then 200 else 300
      # Create card for displaying user's entries
      @card = new Card
        width: cardWidth
        form: 'form'
        container: '.card-wrapper'
        messages:
          fullName: 'NOM COMPLET'
          validDate: 'valid\ndate'
          monthYear: 'mm/aa'
  Template.payment.viewmodel
    paiementInformations: 'Blablabla'
