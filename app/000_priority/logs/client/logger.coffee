@appLog = console
Meteor.startup ->
  window.console = log if window.console?
  if Session.get('IS_MOBILE')
    log.disableAll()
  else
    log.setLevel 'error'
  @appLog = log
  log.log = log.info
