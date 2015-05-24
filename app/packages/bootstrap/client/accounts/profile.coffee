Template.orionBootstrapAccountIndex.onCreated ->
  console.log 'orionBootstrapAccountIndex created'

Template.orionBootstrapAccountsIndex.onCreated ->
  console.log 'orionBootstrapAccountsIndex created'

Template.orionBootstrapAccountPassword.onCreated ->
  console.log 'orionBootstrapAccountPassword created'

Template.orionBootstrapAccountProfile.onCreated ->
  console.log 'orionBootstrapAccountProfile created'

Template.orionBootstrapAccountsInvite.onCreated ->
  console.log 'orionBootstrapAccountsInvite created'

Template.orionBootstrapAccountsUpdateRoles.onCreated ->
  console.log 'orionBootstrapAccountsUpdateRoles created'

Template.orionBootstrapLogin.onCreated ->
  console.log 'orionBootstrapLogin created'

Template.orionBootstrapRegisterWithInvitation.onCreated ->
  console.log 'orionBootstrapRegisterWithInvitation created'

AutoForm.addHooks 'updateProfileForm', onSuccess: -> Router.go 'myAccount.index'
