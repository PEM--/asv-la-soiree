# https://github.com/matteodem/meteor-easy-security
EasySecurity.config
  general: type: 'rateLimit', ms: 1000
  #methods:
  #  createMethod: type: 'rateLimit', ms: 1000 * 10
  #  commentMethod: type: 'throttle', ms: 500
  ignoredMethods: ['clientToken', 'cardPayment']
  maxQueueLength: 200
