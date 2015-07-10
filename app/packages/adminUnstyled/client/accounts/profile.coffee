Template.orionCpAccountIndex.onCreated ->
  orionLog.info 'orionCpAccountIndex created'

Template.orionCpAccountPassword.onCreated ->
  orionLog.info 'orionCpAccountPassword created'

Template.orionCpAccountProfile.onCreated ->
  orionLog.info 'orionCpAccountProfile created'

Template.orionCpAccountsCreate.onCreated ->
  orionLog.info 'orionCpAccountsCreate created'

Template.orionCpAccountsUpdate.onCreated ->
  orionLog.info 'orionCpAccountsUpdate created'

Template.orionCpLogin.onCreated ->
  orionLog.info 'orionCpLogin created'

Template.orionCpRegisterWithInvitation.onCreated ->
  orionLog.info 'orionCpRegisterWithInvitation created'

AutoForm.addHooks 'updateMyProfileForm',
  onSuccess: -> Router.go 'myAccount.index'
