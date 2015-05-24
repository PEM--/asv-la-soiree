Template.orionCpAccountIndex.onCreated ->
  console.log 'orionCpAccountIndex created'

Template.orionCpAccountPassword.onCreated ->
  console.log 'orionCpAccountPassword created'

Template.orionCpAccountProfile.onCreated ->
  console.log 'orionCpAccountProfile created'

Template.orionCpAccountsInvite.onCreated ->
  console.log 'orionCpAccountsInvite created'

Template.orionCpAccountsUpdateRoles.onCreated ->
  console.log 'orionCpAccountsUpdateRoles created'

Template.orionCpLogin.onCreated ->
  console.log 'orionCpLogin created'

Template.orionCpRegisterWithInvitation.onCreated ->
  console.log 'orionCpRegisterWithInvitation created'

AutoForm.addHooks 'updateProfileForm', onSuccess: -> Router.go 'myAccount.index'
