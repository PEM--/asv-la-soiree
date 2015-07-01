class @PaymentController extends RouteController

appLog.info 'Adding payment page'
Router.route '/payment',
  controller: PaymentController
  action: -> @render 'payment'

if Meteor.isClient
  Template.payment.onCreated ->
    appLog.info 'Creating payment screen'
  Template.payment.onRendered ->
    # Create card for displaying user's entries
    (@$ 'form').card Card container: '.card-wrapper'
