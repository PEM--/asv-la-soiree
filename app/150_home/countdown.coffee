if Meteor.isClient
  Template.countdown.onRendered ->
    currentDate = new Date
    futureDate = new Date 'November 27, 2015  19:00:00'
    diff = futureDate.getTime() / 1000 - currentDate.getTime() / 1000
    clock = ($ '.clock').FlipClock diff,
      clockFace: 'DailyCounter'
      language: 'fr'
      countdown: true
      showSeconds: true
