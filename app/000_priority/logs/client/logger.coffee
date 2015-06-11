@appLog = console
Meteor.startup ->
  window.console = log if window.console?
  if IS_MOBILE
    log.disableAll()
  else
    log.setLevel 'info'
    #log.setLevel 'error'
  @appLog = log
  log.log = log.info
