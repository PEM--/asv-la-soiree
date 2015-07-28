@Partners = new orion.collection 'partners',
  singularName: 'partenaire'
  pluralName: 'partenaires'
  title: 'Partenaires'
  link: title: 'Partenaires'
  tabular: columns: [
    { data: 'name', title: 'Nom' }
    { data: 'category', title: 'Catégorie' }
    orion.attributeColumn('image', 'logo', 'Logo')
  ]

Partners.attachSchema new SimpleSchema
  name: type: String, label: 'Nom'
  url: type: String, label: 'URL'
  category:
    type: String
    label: 'Catégorie'
    allowedValues: ['gold', 'silver', 'bronze']
  logo: orion.attribute 'image', label: 'Logo'
