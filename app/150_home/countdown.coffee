if Meteor.isClient

  class @ClockSingleton
    instance = null
    @get: -> instance
    @instanciate: ($clock) -> instance = new Clock $clock
    class Clock
      constructor: (@$clock) ->
        @futureDate = new Date 'November 27, 2015  19:00:00'
        diff = diff = @futureDate.getTime() / 1000 -
          (new Date).getTime() / 1000
        @flipClock = @$clock.FlipClock diff,
          clockFace: 'DailyCounter'
          language: 'fr'
          autoStart: false
          countdown: true
          showSeconds: true
      start: ->
        appLog.info 'Clock started'
        diff = @futureDate.getTime() / 1000 - (new Date).getTime() / 1000
        @flipClock.setTime diff
        @flipClock.start()
      stop: ->
        appLog.info 'Clock stopped'
        @flipClock.stop()

  Template.countdown.onRendered ->
    clockInst = ClockSingleton.instanciate @$ '.clock'
