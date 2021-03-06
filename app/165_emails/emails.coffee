MANDRILL_CONFS = [
  {
    key: 'smtp_username', type: String
    label: 'Email du détenteur du compte'
  }
  {
    key: 'api_key', type: String
    label: 'Identifiant de l\'application'
  }
  {
    key: 'template_slug', type: String
    label: 'Slug du template d\'email'
  }
]

# Create configuration for Mandrill (available in Orion's configuration)
if Meteor.isServer
  config = orion.config.collection.findOne()
  changed = false
for conf in MANDRILL_CONFS
  # Mandrill account in the CMS secret informations
  confKey = "MANDRILL_#{conf.key.toUpperCase()}"
  orion.config.add confKey, 'mandrill',
    type: conf.type
    label: "#{conf.label} (#{confKey})"
  # Create default values for the Mandrill configuration
  if Meteor.isServer
    unless config[confKey]?
      config[confKey] = Meteor.settings.mandrill[conf.key]
      changed = true
if Meteor.isServer
  if changed
    appLog.info 'Creating or updating Mandrill configuration'
    orion.config.collection.update config._id, $set: config
  Meteor.startup ->
    appLog.info 'Connecting to Mandrill'
    Mandrill.config
      username: orion.config.get 'MANDRILL_SMTP_USERNAME'
      key: orion.config.get 'MANDRILL_API_KEY'
  ###*
   * Send a templated and transactional email via Mandrill.
   * @param  {String} order_id Unique order ID.
   * @param  {String} email    Email of the recipient.
   * @param  {String} fullname Fullname of the recipient.
   * @param  {String} price    A formatted price for the invitation.
   * @param  {String} tag      A description of the price.
  ###
  @sendTransactionEmail = (order_id, email, fullname, price, tag) ->
    Mandrill.messages.sendTemplate
      template_name: orion.config.get 'MANDRILL_TEMPLATE_SLUG'
      template_content: [
        { name: 'order_id', content: order_id }
        { name: 'fullname', content: fullname }
        { name: 'price', content: price }
        { name: 'tag', content: tag }
      ]
      message:
        to: [ { email: email } ]
        attachments: [
          {
            type: 'application/pdf'
            name: 'Conditions générales de ventes.pdf'
            content: CgvPdf
          }
        ]
  # Observe changes on payment information for sending emails
  Subscribers.find().observeChanges
    'changed': (id, fields) ->
      if fields.paymentStatus? and fields.paymentStatus is true
        sub = Subscribers.findOne id
        pricing = PRICING_TABLE[sub.profile]
        sendTransactionEmail sub.easyInvitationId, sub.email,
          "#{sub.forname} #{sub.name}",
          numeral(pricing.amount).format('0,0.00$'),
          pricing.tag
