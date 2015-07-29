@Partners = new orion.collection 'partners',
  singularName: 'partenaire'
  pluralName: 'partenaires'
  title: 'Partenaires'
  link: title: 'Partenaires'
  tabular: columns: [
    { data: 'name', title: 'Nom' }
    { data: 'category', title: 'Catégorie' }
  ]

Partners.attachSchema new SimpleSchema
  name: type: String, label: 'Nom'
  url: type: String, label: 'URL'
  category:
    type: String
    label: 'Catégorie'
    allowedValues: ['gold', 'silver', 'bronze']
  logo: orion.attribute 'image', label: 'Logo (120x120, PNG)'

if Meteor.isClient
  Template.partners.onCreated ->
    @subscribe 'partners'

  Template.partners.helpers
    gold: -> Partners.find category: 'gold'
    silver: -> Partners.find category: 'silver'
    bronze: -> Partners.find category: 'bronze'

if Meteor.isServer
  Meteor.publish 'partners', -> Partners.find()
