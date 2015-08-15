# Global admin option
for option in ['homePath', 'siteName']
  Options.init option
# Reactive templates
ReactiveTemplates.request 'tabs', 'orionCpTabs'
ReactiveTemplates.request 'adminSidebar'
for rxTpl in [
  {name: 'layout', layout: 'orionCpLayout'}
  {name: 'outAdminLayout', layout: 'orionCpOutAdminLayout'}

  {name: 'adminSidebar', layout: 'orionCpSidebar'}
  {name: 'login', layout: 'orionCpLogin'}
  {name: 'registerWithInvitation', layout: 'orionCpRegisterWithInvitation'}

  {name: 'myAccount.index', layout: 'orionCpAccountIndex'}
  {name: 'myAccount.password', layout: 'orionCpAccountPassword'}
  {name: 'myAccount.profile', layout: 'orionCpAccountProfile'}

  {name: 'accounts.index', layout: 'orionCpAccountsIndex'}
  {name: 'accounts.update', layout: 'orionCpAccountsUpdate'}
  {name: 'accounts.create', layout: 'orionCpAccountsCreate'}

  {name: 'configUpdate', layout: 'orionCpConfigUpdate'}
  {name: 'dictionaryUpdate', layout: 'orionCpDictionaryUpdate'}
]
  orion.log.info "Registering template #{rxTpl.name} with layout #{rxTpl.layout}"
  ReactiveTemplates.set rxTpl.name, rxTpl.layout
# Set the default entity templates
for entity in [
  {tpl: 'collectionsDefaultIndexTemplate', action: 'orionCpCollectionsIndex'}
  {tpl: 'collectionsDefaultCreateTemplate', action: 'orionCpCollectionsCreate'}
  {tpl: 'collectionsDefaultUpdateTemplate', action: 'orionCpCollectionsUpdate'}
  {tpl: 'collectionsDefaultDeleteTemplate', action: 'orionCpCollectionsDelete'}
]
  orion.log.info "Set entity #{entity.tpl} with template #{entity.action}"
  Options.set entity.tpl, entity.action

if Meteor.isClient
  orion.log.info 'Use the default plain template for Autoform'
  AutoForm.setDefaultTemplate 'plain'

# Reactive template on pages
# for rxTpl in [
#   {name: 'pages.index', layout: 'orionCpPagesIndex'}
#   {name: 'pages.create', layout: 'orionCpPagesCreate'}
#   {name: 'pages.update', layout: 'orionCpPagesUpdate'}
#   {name: 'pages.delete', layout: 'orionCpPagesDelete'}
# ]
#   orion.log.info "Registering template #{rxTpl.name} with layout #{rxTpl.layout}"
#   ReactiveTemplates.set rxTpl.name, rxTpl.layout
