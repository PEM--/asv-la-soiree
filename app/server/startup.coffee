# Default PLT page: Injected initial styles and content
#  for boosting SEO ranking.
Inject.rawHead 'loader-style',
  # Force the initial scale for Android and iOS as our spinner may be
  #  distorted by their default viewport values.
  '<meta name="viewport" content="width=device-width,maximum-scale=1,' +
    'initial-scale=1,user-scalable=no">' +
  # The loading spinner needs some theming.
  '<style>' +
    "html{background-color: #{colorTheme.bgBrandColor};}" +
    "body{color:#{colorTheme.bgBrandColor};overflow:hidden;width:100%;}" +
    '.initial-spinner {' +
      'bottom:0;height:80px;left:0;margin:auto;position:absolute;' +
      'top:0;right:0;width:80px;' +
      '-webkit-animation: rotation .6s infinite linear;' +
      'animation: rotation .6s infinite linear;' +
      "border-left:6px solid #{colorTheme.transBrandColor};" +
      "border-right:6px solid #{colorTheme.transBrandColor};" +
      "border-bottom:6px solid #{colorTheme.transBrandColor};" +
      "border-top:6px solid #{colorTheme.brandColor};" +
      'border-radius:100%;' +
    '}' +
    '@-webkit-keyframes rotation {' +
      'from {-webkit-transform: rotate(0deg);}' +
      'to {-webkit-transform: rotate(359deg);}' +
    '}' +
    '@-moz-keyframes rotation {' +
      'from {-moz-transform: rotate(0deg);}' +
      'to {-moz-transform: rotate(359deg);}' +
    '}' +
    '@-o-keyframes rotation {' +
      'from {-o-transform: rotate(0deg);}' +
      'to {-o-transform: rotate(359deg);}' +
    '}' +
    '@keyframes rotation {' +
      'from {transform: rotate(0deg);}' +
      'to {transform: rotate(359deg);}' +
    '}' +
    '</style>'
Inject.rawHead 'loader-body2',
  '<body><div class="initial-spinner"></div></body>'

# OrionJS options
Options.set 'forbidClientAccountCreation', true
