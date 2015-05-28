@appLog = console
Meteor.startup ->
  # @TODO https://github.com/adamschwartz/log
  # @TODO https://github.com/artemyarulin/loglevel-serverSend
  window.console = log if window.console?
  log.setLevel 'warn'
  @appLog = log
  log.log = log.info
