if Meteor.isClient
  Template.contact.onRendered ->
    @viewmodel.isContactPrevented CookieSingleton.get().isContacted()
    # Avoid error text when screen is created
    Meteor.defer =>
      @viewmodel.errorText ''

  Template.contact.viewmodel
    isCookieAccepted: -> CookieSingleton.get().isAccepted()
    isContactPrevented: false
    errorText: ''
    name: ''
    email: ''
    message: ''
    disabledSubmit: ->
      obj =
        name: @name()
        email: @email()
        message: @message()
      appLog.info 'Contact values: ', obj
      try
        check obj, ContactsSchema
      catch error
        text = (error.message.split 'Match error: ')[1]
        # Reformat error message if necessary
        appLog.info 'Contact not filled: ',text
        @setErrorText text
        return true
      # Reset error text when field seems OK
      @errorText ''
      return false
    setErrorText: (text) ->
      # text = switch text
      #   when ' n\'est pas une valeur autorisée'
      #     'Choisissez votre profil'
      #   when  'N° de téléphone ne satisfait pas l\'expression régulière', \
      #         'N° de téléphone doit être supérieur ou égal à [min]'
      #     'Le n° de téléphone doit être du type: 0612345678'
      #   when  'Internal server error'
      #     'Nous n\'étions pas prêts. Pourriez-vous ré-essayer plus tard ?'
      #   else text
      @errorText text
    sendMessage: (e) ->
      obj =
        name: @name()
        email: @email()
        message: @message()
      appLog.info 'Ask contact attempt', obj
      unless Match.test obj, ContactsSchema
        appLog.warn 'Contact failed, match is incorrect'
        @setErrorText 'Veuillez vérifier vos informations'
      else
        Meteor.call 'askContact', obj, (error, result) =>
          # Display an error message and do not store the contact cookie
          if error and error.error isnt 'askContact.already'
            appLog.warn 'askContact failed', error.reason, error
            return @setErrorText error.reason
          if error and error.error is 'askContact.already'
            appLog.warn 'Contact already done'
            sAlert.warning error.reason
          # Store the contact so that it cannot be done twice
          CookieSingleton.get().askContact obj
          # Reset the form and mask contact
          @reset()
          @isContactPrevented true

Meteor.methods
  askContact: (obj) ->
    check obj, ContactsSchema
    try
      Contacts.insert _.extend obj, createdAt: new Date
      appLog.info 'Inserted new contact demand', obj
    catch error
      appLog.warn error, typeof error
      if ((JSON.stringify error).search 'duplicate') isnt -1
        throw new Meteor.Error 'askContact.already',
          'Vous avez déjà requis une demande de contact'
      else
        throw new Meteor.Error 'askContact', 'Internal server error'

# Contacts
@Contacts = new orion.collection 'contacts',
  singularName: 'contact'
  pluralName: 'contacts'
  title: 'Contacts'
  link: title: 'Contacts'
  tabular:
    columns: [
      { data: 'name', title: 'Nom' }
      { data: 'email', title: 'E-mail' }
      { data: 'message', title: 'Message' }
      {
        data: 'createdAt', title: 'Contact demandé le'
        render: (val, type, doc) ->
          if val instanceof Date
            return moment(val).calendar()
          return 'Date de contact manquante'
      }
    ]

# Set only the fields required in the UI
@ContactsSchema = new SimpleSchema
  name:
    type: String
    label: 'Nom'
    min: 2
    max: 128
  email:
    type: String
    label: 'E-mail'
    regEx: SimpleSchema.RegEx.Email
    unique: true
    min: 5
    max: 256
  message:
    type: String
    min: 60
    max: 1024
    autoform: type: 'textarea'

# Add the fields for the DB and the admin UI
ContactsFullSchema = new SimpleSchema [
  ContactsSchema
  { createdAt: orion.attribute 'createdAt' }
]

Contacts.attachSchema ContactsFullSchema
