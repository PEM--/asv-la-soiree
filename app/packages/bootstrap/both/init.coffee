# Global admin option
for option in ['homePath', 'siteName']
  Options.init option
# Reactive templates
ReactiveTemplates.request 'tabs', 'orionBootstrapTabs'
for rxTpl in [
  {name: 'layout', layout: 'orionBootstrapLayout'}
  {name: 'outAdminLayout', layout: 'orionBootstrapOutAdminLayout'}

  {name: 'links', layout: 'orionBootstrapSidebar'}
  {name: 'login', layout: 'orionBootstrapLogin'}
  {name: 'registerWithInvitation', layout: 'orionBootstrapRegisterWithInvitation'}

  {name: 'myAccount.index', layout: 'orionBootstrapAccountIndex'}
  {name: 'myAccount.password', layout: 'orionBootstrapAccountPassword'}
  {name: 'myAccount.profile', layout: 'orionBootstrapAccountProfile'}

  {name: 'accounts.index', layout: 'orionBootstrapAccountsIndex'}
  {name: 'accounts.update.roles', layout: 'orionBootstrapAccountsUpdateRoles'}
  {name: 'accounts.invite', layout: 'orionBootstrapAccountsInvite'}

  {name: 'configUpdate', layout: 'orionBootstrapConfigUpdate'}
  {name: 'dictionaryUpdate', layout: 'orionBootstrapDictionaryUpdate'}
]
  console.log 'Registering template', rxTpl.name, 'with layout', rxTpl.layout
  ReactiveTemplates.set rxTpl.name, rxTpl.layout
# Set the default entity templates
for entity in [
  {
    tpl: 'collectionsDefaultIndexTemplate',
    action: 'orionBootstrapCollectionsIndex'
  }
  {
    tpl: 'collectionsDefaultCreateTemplate',
    action: 'orionBootstrapCollectionsCreate'
  }
  {
    tpl: 'collectionsDefaultUpdateTemplate',
    action: 'orionBootstrapCollectionsUpdate'
  }
  {
    tpl: 'collectionsDefaultDeleteTemplate',
    action: 'orionBootstrapCollectionsDelete'
  }
]
  console.log 'Set entity', entity.tpl, 'on template action', entity.action
  Options.set entity.tpl, entity.action

if Meteor.isClient
  console.log 'Use the default plain template for Autoform'
  AutoForm.setDefaultTemplate 'plain'

# Reactive template on pages
for rxTpl in [
  {name: 'pages.index', layout: 'orionBootstrapPagesIndex'}
  {name: 'pages.create', layout: 'orionBootstrapPagesCreate'}
  {name: 'pages.update', layout: 'orionBootstrapPagesUpdate'}
  {name: 'pages.delete', layout: 'orionBootstrapPagesDelete'}
]
  console.log 'Registering template', rxTpl.name, 'with layout', rxTpl.layout
  ReactiveTemplates.set rxTpl.name, rxTpl.layout
