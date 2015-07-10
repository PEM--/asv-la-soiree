Template.orionCpSidebar.onRendered ->
  @autorun =>
    depend = orion.links._collection.find().fetch()
    #(@$ '.orion-links a[data-toggle=\'collapse\']').collapse()
