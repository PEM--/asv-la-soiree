@appLog = console
Meteor.startup ->
  # @TODO https://github.com/adamschwartz/log
  # @TODO https://github.com/artemyarulin/loglevel-serverSend
  window.console = log if window.console?
  if Session.get('IS_MOBILE')
    log.disableAll()
  else
    log.setLevel 'info'
  @appLog = log
  log.log = log.info
