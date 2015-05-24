Template.orionCpAccountIndex.onCreated ->
  orionLog.info 'orionCpAccountIndex created'

Template.orionCpAccountPassword.onCreated ->
  orionLog.info 'orionCpAccountPassword created'

Template.orionCpAccountProfile.onCreated ->
  orionLog.info 'orionCpAccountProfile created'

Template.orionCpAccountsInvite.onCreated ->
  orionLog.info 'orionCpAccountsInvite created'

Template.orionCpAccountsUpdateRoles.onCreated ->
  orionLog.info 'orionCpAccountsUpdateRoles created'

Template.orionCpLogin.onCreated ->
  orionLog.info 'orionCpLogin created'

Template.orionCpRegisterWithInvitation.onCreated ->
  orionLog.info 'orionCpRegisterWithInvitation created'

AutoForm.addHooks 'updateProfileForm', onSuccess: -> Router.go 'myAccount.index'
