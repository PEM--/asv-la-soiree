class @PaymentController extends AppCtrl
  layoutTemplate = null

appLog.info 'Adding payment page'
Router.route '/payment',
  controller: PaymentController
  action: -> @render 'payment'

if Meteor.isClient

  Template.payment.onCreated ->
    appLog.info 'Creating payment screen'
