Template.orionCpAccountIndex.onCreated ->
  orion.log.info 'orionCpAccountIndex created'

Template.orionCpAccountPassword.onCreated ->
  orion.log.info 'orionCpAccountPassword created'

Template.orionCpAccountProfile.onCreated ->
  orion.log.info 'orionCpAccountProfile created'

Template.orionCpAccountsCreate.onCreated ->
  orion.log.info 'orionCpAccountsCreate created'

Template.orionCpAccountsUpdate.onCreated ->
  orion.log.info 'orionCpAccountsUpdate created'

Template.orionCpLogin.onCreated ->
  orion.log.info 'orionCpLogin created'

Template.orionCpRegisterWithInvitation.onCreated ->
  orion.log.info 'orionCpRegisterWithInvitation created'

AutoForm.addHooks 'updateMyProfileForm',
  onSuccess: -> RouterLayer.go 'myAccount.index'
