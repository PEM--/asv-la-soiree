# Site wide values
orion.dictionary.addDefinition 'title', 'site',
  type: String, label: 'Titre'
orion.dictionary.addDefinition 'description', 'site',
  type: String, label: 'Description', autoform: type: 'textarea'
orion.dictionary.addDefinition 'lastModified', 'site',
  type: Date, label: 'Dernière modification (utile pour indiquer au moteur de \
    recherche que de nouvelles informations sont disponibles)', \
    autoform: type: 'date'
# SEO and social accounts
orion.dictionary.addDefinition 'twitter.site', 'social',
  type: String, label: 'Compte Twitter du site'
orion.dictionary.addDefinition 'twitter.creator', 'social',
  type: String, label: 'Compte Twitter de l\'auteur'
orion.dictionary.addDefinition 'gplus.publisher', 'social',
  type: String, label: 'Compte G+ de l\'éditeur'
orion.dictionary.addDefinition 'gplus.author', 'social',
  type: String, label: 'Compte G+ de l\'auteur'

# Rich snippet event
rsEvent = ->
  '{' +
    '"@context": "http://schema.org",' +
    '"@type": "Event",' +
    "\"name\": \"#{orion.dictionary.get 'site.title'}\"," +
    '"startDate" : "2015-11-27T18:00:00.000Z",' +
    "\"url\" : \"#{Meteor.settings.proxy.url}\"," +
    "\"image\": \"#{Meteor.settings.proxy.url}/favicon-96x96.png\"," +
    '"location" : {' +
      '"@type" : "Place",' +
      '"name" : "La Plateforme",' +
      '"address" : "4, quai Victor Augagneur - 69003 Lyon"' +
    '},' +
    '"offers": {' +
      '"@type": "AggregateOffer",' +
      "\"lowPrice\": \"#{PRICING_TABLE.asv_graduate.amount}\"," +
      "\"highPrice\": \"#{PRICING_TABLE.attendant.amount}\"," +
      '"priceCurrency": "EUR",' +
      "\"url\": \"#{Meteor.settings.proxy.url}/#subscription\"" +
    '}' +
  '}'

if Meteor.isServer
  @seoHeadValues = ->
    res = {}
    for key in [
      'site.title'
      'site.description'
      'social.twitter.site'
      'social.twitter.creator'
      'social.gplus.publisher'
      'social.gplus.author'
    ]
      orionDictKey = orion.dictionary.get key
      res[key] = if orionDictKey is ''
        eval "Meteor.settings.dictionary.#{key}"
      else
        orionDictKey
    res.lastModified = new Date
    res

  @htmlHeadInjectedContent = ->
    # Title and description: Basic SEO values
    "<title data-bind='html: title'>#{orion.dictionary.get 'site.title'}" +
      '</title>' +
    '<meta name=\'description\' ' +
      "content='#{orion.dictionary.get 'site.description'}' " +
      'data-bind=\'value: description, attr: { content: description }\'>' +
    # Twitter card
    # Note that twitter card uses some of the OpenGraph values for its content.
    '<meta name=\'twitter:card\' content=\'summary_large_image\' />' +
    '<meta name=\"twitter:site\" ' +
      "content='#{orion.dictionary.get 'social.twitter.site'}' " +
      'data-bind=\'value: twitterSite, attr: { content: twitterSite }\'/>' +
    '<meta name=\'twitter:creator\' ' +
      "content='#{orion.dictionary.get 'social.twitter.creator'}' " +
      'data-bind=\'value: twitterCreator, attr: { content: twitterCreator }\'' +
    '/>' +
    # Open graph
    '<meta property=\'og:url\' ' +
      "content='#{Meteor.settings.proxy.url}' />" +
    '<meta property=\'og:type\' content=\'website\' />' +
    '<meta property=\'og:locale\' content=\'fr_FR\' />' +
    '<meta property=\'og:title\' ' +
      "content='#{orion.dictionary.get 'site.title'}' " +
      'data-bind=\'value: title, attr: { content: title }\'/>' +
    '<meta property=\'og:site_name\' ' +
      "content='#{orion.dictionary.get 'site.title'}' " +
      'data-bind=\'value: title, attr: { content: title }\'/>' +
    '<meta property=\'og:description\' ' +
      "content='#{orion.dictionary.get 'site.description'}' " +
      'data-bind=\'value: description, attr: { content: description }\'/>' +
    '<meta property=\'og:image\' ' +
      "content='#{Meteor.settings.proxy.url}/img/twitter-card.jpg' />" +
    # Rich snippets
    '<script type="application/ld+json" data-bind=\'text: rsEvent\'>' +
      rsEvent() +
    '</script>' +
    # G+
    '<link rel=\'publisher\' ' +
      "href='#{orion.dictionary.get 'social.gplus.publisher'}' " +
      'data-bind=\'value: gplusPublisher, attr: { href: gplusPublisher }\'>' +
    '<link rel=\'author\' ' +
      "href='#{orion.dictionary.get 'social.gplus.author'}' " +
      'data-bind=\'value: gplusAuthor, attr: { href: gplusAuthor }\'>'

if Meteor.isClient
  Meteor.startup ->
    # Inject lang in the html tag
    ($ 'html').attr 'lang', 'fr'
    # Create all meta informations for SEO
    $head = $ 'head'
    # Ensure that the SEO ViewModel is never instantiated twice
    @SeoViewModel = null
    # Wait for Orion's dictionary to get ready
    Tracker.autorun =>
      isDictReady = not not orion.dictionary.findOne()
      unless isDictReady
        # This case shouldn't exist, logs it if it happens
        appLog.warn 'Orion\'s dictionary isn\'t ready yet'
        return
      appLog.info 'Orion\'s dictionnary is ready. \
        Start real time modification of SEO values.'
      # Wait for jQuery to stabilyze
      Meteor.defer =>
        # Create or update reactive SEO data structure
        if SeoViewModel is null
          appLog.info 'SEO reactive information are set on the <head>.'
          @SeoViewModel = new ViewModel
            title: -> orion.dictionary.get 'site.title'
            description: -> orion.dictionary.get 'site.description'
            twitterSite: -> orion.dictionary.get 'social.twitter.site'
            twitterCreator: -> orion.dictionary.get 'social.twitter.creator'
            rsEvent: -> rsEvent()
            gplusPublisher: -> orion.dictionary.get 'social.gplus.publisher'
            gplusAuthor: -> orion.dictionary.get 'social.gplus.author'
          @SeoViewModel.bind $head
        else
          # Note that the reactivity in the viewmodel changes the automatically
          #  the information. There's no need for additional calls.
          appLog.info 'Dictionary updated, changing SEO values.'
