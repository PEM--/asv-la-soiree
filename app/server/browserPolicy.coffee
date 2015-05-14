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
rootUrl = __meteor_runtime_config__.ROOT_URL
BrowserPolicy.content.allowConnectOrigin rootUrl
BrowserPolicy.content.allowConnectOrigin (rootUrl.replace 'http', 'ws')
# Allow origin for Meteor hosting
for protocol in ['http', 'https', 'ws', 'wss']
  BrowserPolicy.content.allowConnectOrigin "#{protocol}://*.meteor.com"
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
for origin in ['*.google-analytics.com', 'browser-update.org']
  for protocol in ['http', 'https']
    origin = "#{protocol}://#{origin}"
    BrowserPolicy.content.allowOriginForAll origin
