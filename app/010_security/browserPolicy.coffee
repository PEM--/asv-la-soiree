if Meteor.isServer
  # Article sources:
  # * https://dweldon.silvrback.com/browser-policy
  # * http://paris.meteor.com/presentations/uByDe8qDLrNGJLzMC
  # * https://github.com/meteor/meteor/tree/21bdac87347e0c80bbdf4fdbca132ff80033b3f3/packages/browser-policy
  # Black list everything
  BrowserPolicy.framing.disallow()
  BrowserPolicy.content.disallowEval()
  # BrowserPolicy.content.disallowInlineScripts()
  BrowserPolicy.content.disallowConnect()
  # Only allow necessary protocols
  appLog.info 'Settings', Meteor.settings.public.proxy.url
  # Allow origin for Meteor hosting
  for origin in [
    '*.meteor.com'
    '*.asv-la-soiree.com'
    Meteor.absoluteUrl().split('://')[1]
    Meteor.absoluteUrl('*').split('://')[1]
  ]
    for protocol in ['http', 'https', 'ws', 'wss']
      url = "#{protocol}://#{origin}"
      appLog.info 'Authorizing', url
      BrowserPolicy.content.allowConnectOrigin url
  # Allow external CSS
  for origin in ['fonts.googleapis']
    for protocol in ['http', 'https']
      BrowserPolicy.content.allowStyleOrigin "#{protocol}://#{origin}"
  # Allow external fonts
  for origin in ['fonts.gstatic.com']
    for protocol in ['http', 'https']
      BrowserPolicy.content.allowFontOrigin "#{protocol}://#{origin}"
  # Allow Fonts and CSS
  for protocol in ['http', 'https']
    BrowserPolicy.content.allowStyleOrigin "#{protocol}://fonts.googleapis.com"
    BrowserPolicy.content.allowFontOrigin "#{protocol}://fonts.gstatic.com"
  # Trusted sites
  for origin in [
    # Google services
    '*.google-analytics.com'
    '*.googleapis.com'
    '*.gstatic.com'
    # Browser update warning
    'browser-update.org'
    # Braintree
    '*.braintreegateway.com'
    # Mix Panel analytics
    #'cdn.mxpnl.com'
    # Kadira
    '*.kadira.io'
    # Meteor
    '*.meteor.com'
    # Meteor
    '*.asv-la-soiree.com'
  ]
    for protocol in ['http', 'https']
      porigin = "#{protocol}://#{origin}"
      BrowserPolicy.content.allowOriginForAll porigin
      BrowserPolicy.content.allowEval porigin
