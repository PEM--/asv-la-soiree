# Inner links are links in the landing page
@InnerLinks = new orion.collection 'innerlinks',
  singularName: 'lien interne'
  pluralName: 'liens internes'
  title: 'Liens internes'
  link: title: 'Liens SPA'
  tabular:
    # Set only the fields required in the Admin UI
    columns: [
      { data: 'title', title: 'Titre' }
      { data: 'order', title: 'Ordre' }
      { data: 'slug', title: 'Slug' }
    ]

knownSlugs = [
  '#subscription'
  '#program'
  '#contact'
]

@InnerLinksSchema = new SimpleSchema
  title:
    type: String
    label: 'Titre'
  order:
    type: Number
    label: 'Ordre d\'affichage'
    unique: true
  slug:
    type: String
    label: 'Slug'
    allowedValues: knownSlugs

InnerLinks.attachSchema InnerLinksSchema

# Create 3 default inner links on the home page
if Meteor.isServer

  defaultTitles = [
    'Inscription'
    'Programme'
    'Contact'
  ]

  appLog.info 'Checking inner links'
  try
    for title, idx in defaultTitles
      if InnerLinks.find(slug: knownSlugs[idx]).count() is 0
        appLog.info 'No links for', knownSlugs[idx], '. Creating one.'
        InnerLinks.insert
          title: title
          order: idx + 1
          slug: knownSlugs[idx]
  catch err
    appLog.error err.reason
  # Publish inner lnks
  Meteor.publish 'innerlinks', -> InnerLinks.find()
