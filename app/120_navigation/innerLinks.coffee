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
      { data: 'slug', title: 'Slug' }
    ]

knownSlugs = [
  '#program'
  '#subscription'
  '#contact'
]

defaultTitles = [
  'Inscription'
  'Programme'
  'Contact'
]

@InnerLinksSchema = new SimpleSchema
  title:
    type: String
    label: 'Titre'
  slug:
    type: String
    label: 'Slug'
    allowedValues: knownSlugs

InnerLinks.attachSchema InnerLinksSchema

# Create 3 default inner links on the home page
if Meteor.isServer
  try
    for title, idx in defaultTitles
      if InnerLinks.find(slug: knownSlugs[idx]).count is 0
        appLog.info 'No links for ', knownSlugs[idx], 'Creating one.'
        InnerLinks.insert
          title: title
          slug: knownSlugs[idx]
  catch err
    appLog.error err.reason
  # Publish inner lnks
  Meteor.publish 'innerlinks', -> InnerLinks.find()
