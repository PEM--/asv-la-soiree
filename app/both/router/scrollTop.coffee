Iron.Router.plugins.scrollTop = (router, options) ->
  # This loading plugin just creates an onBeforeAction hook
  router.onAfterAction 'scrollTop', options
