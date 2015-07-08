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

if Meteor.isServer
  @htmlHeadInjectedContent = ->
    # Title and description: Basic SEO values
    "<title data-bind='html: title'>#{orion.dictionary.get 'site.title'}" +
      '</title>' +
    '<meta name=\'description\' ' +
      "content='#{orion.dictionary.get 'site.description'}' " +
      'data-bind=\'value: description, attr: { content: description }\'>' +
    # Twitter card
    # Note that twitter card uses some of the OpenGraph values for its content.
    '<meta name="twitter:card" content="summary" />' +
    '<meta name="twitter:site" content="' +
      orion.dictionary.get 'social.twitter.site'
    '" />' +
    '<meta name="twitter:creator" content="' +
      orion.dictionary.get 'social.twitter.creator'
    '" />' +

    # @TODO Finalize SEO on G+
    '<link rel=\'publisher\' ' +
      'href=\'https://plus.google.com/105839099099011364699\'>' +
    '<link rel=\'author\' ' +
      'href=\'https://plus.google.com/+PierreEricMarchandet\'>'


  @seoHeadValues = ->
    res =
      site:
        title: 'ASV, la soirée'
        description: 'Une super soirée pour le congrès des ASV, \
          les auxiliaires vétérinaires.'
        lastModified: new Date()
      social:
        twitter:
          site: '@apform'
          creator: '@PEM___'
    res
