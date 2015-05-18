# Global admin option
for option in ['homePath', 'siteName']
  Options.init option
# Reactive templates
ReactiveTemplates.request 'tabs', 'orionCpTabs'
for rxTpl in [
  {name: 'layout', layout: 'orionCpLayout'}
  {name: 'outAdminLayout', layout: 'orionCpOutAdminLayout'}
  {name: 'links', layout: 'orionCpSidebar'}
  {name: 'login', layout: 'orionCpLogin'}
  {name: 'registerWithInvitation', layout: 'orionCpRegisterWithInvitation'}
  {name: 'myAccount.index', layout: 'orionCpAccountIndex'}
  {name: 'myAccount.password', layout: 'orionCpAccountPassword'}
  {name: 'myAccount.profile', layout: 'orionCpAccountProfile'}
  {name: 'accounts.index', layout: 'orionCpAccountsIndex'}
  {name: 'accounts.update.roles', layout: 'orionCpAccountsUpdateRoles'}
  {name: 'accounts.invite', layout: 'orionCpAccountsInvite'}
  {name: 'configUpdate', layout: 'orionCpConfigUpdate'}
  {name: 'dictionaryUpdate', layout: 'orionCpDictionaryUpdate'}
]
  ReactiveTemplates.set rxTpl.name, rxTpl.layout
# Set the default entity templates
for entity in [
  {tpl: 'collectionsDefaultIndexTemplate', action: 'orionCpCollectionsIndex'}
  {tpl: 'collectionsDefaultCreateTemplate', action: 'orionCpCollectionsCreate'}
  {tpl: 'collectionsDefaultUpdateTemplate', action: 'orionCpCollectionsUpdate'}
  {tpl: 'collectionsDefaultDeleteTemplate', action: 'orionCpCollectionsDelete'}
]
  Options.set entity.tpl, entity.action
# Reactive template on pages
for rxTpl in [
  {name: 'pages.index', layout: 'orionCpPagesIndex'}
  {name: 'pages.create', layout: 'orionCpPagesCreate'}
  {name: 'pages.update', layout: 'orionCpPagesUpdate'}
  {name: 'pages.delete', layout: 'orionCpPagesDelete'}
]
  ReactiveTemplates.set rxTpl.name, rxTpl.layout