#@orionLog = new Logger 'orion'
@orionLog = console

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
  {name: 'accounts.update', layout: 'orionCpAccountsUpdate'}
  {name: 'accounts.create', layout: 'orionCpAccountsCreate'}

  {name: 'configUpdate', layout: 'orionCpConfigUpdate'}
  {name: 'dictionaryUpdate', layout: 'orionCpDictionaryUpdate'}
]
  orionLog.info "Registering template #{rxTpl.name} with layout #{rxTpl.layout}"
  ReactiveTemplates.set rxTpl.name, rxTpl.layout
# Set the default entity templates
for entity in [
  {tpl: 'collectionsDefaultIndexTemplate', action: 'orionCpCollectionsIndex'}
  {tpl: 'collectionsDefaultCreateTemplate', action: 'orionCpCollectionsCreate'}
  {tpl: 'collectionsDefaultUpdateTemplate', action: 'orionCpCollectionsUpdate'}
  {tpl: 'collectionsDefaultDeleteTemplate', action: 'orionCpCollectionsDelete'}
]
  orionLog.info "Set entity #{entity.tpl} with template #{entity.action}"
  Options.set entity.tpl, entity.action

if Meteor.isClient
  orionLog.info 'Use the default plain template for Autoform'
  AutoForm.setDefaultTemplate 'plain'

# Reactive template on pages
for rxTpl in [
  {name: 'pages.index', layout: 'orionCpPagesIndex'}
  {name: 'pages.create', layout: 'orionCpPagesCreate'}
  {name: 'pages.update', layout: 'orionCpPagesUpdate'}
  {name: 'pages.delete', layout: 'orionCpPagesDelete'}
]
  orionLog.info "Registering template #{rxTpl.name} with layout #{rxTpl.layout}"
  ReactiveTemplates.set rxTpl.name, rxTpl.layout
