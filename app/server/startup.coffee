# Default PLT page: Injected initial styles and content
#  for boosting SEO ranking.
Inject.rawHead 'loader-style',
  # Force the initial scale for Android and iOS as our spinner may be
  #  distorted by their default viewport values.
  '<meta name="viewport" content="width=device-width,maximum-scale=1,' +
    'initial-scale=1,user-scalable=no">' +
  # Tell Google that it's an heavy JS app
  '<meta name="fragment" content="!">' +
  # Favicons
  '<link rel="apple-touch-icon" sizes="57x57" ' +
    'href="/apple-touch-icon-57x57.png">' +
  '<link rel="apple-touch-icon" sizes="60x60" ' +
    'href="/apple-touch-icon-60x60.png">' +
  '<link rel="apple-touch-icon" sizes="72x72" ' +
    'href="/apple-touch-icon-72x72.png">' +
  '<link rel="apple-touch-icon" sizes="76x76" ' +
    'href="/apple-touch-icon-76x76.png">' +
  '<link rel="apple-touch-icon" sizes="114x114" ' +
    'href="/apple-touch-icon-114x114.png">' +
  '<link rel="apple-touch-icon" sizes="120x120" ' +
    'href="/apple-touch-icon-120x120.png">' +
  '<link rel="apple-touch-icon" sizes="144x144" ' +
    'href="/apple-touch-icon-144x144.png">' +
  '<link rel="apple-touch-icon" sizes="152x152" ' +
    'href="/apple-touch-icon-152x152.png">' +
  '<link rel="apple-touch-icon" sizes="180x180" ' +
    'href="/apple-touch-icon-180x180.png">' +
  '<link rel="icon" type="image/png" ' +
    'href="/favicon-32x32.png?v=2" sizes="32x32">' +
  '<link rel="icon" type="image/png" ' +
    'href="/android-chrome-192x192.png" sizes="192x192">' +
  '<link rel="icon" type="image/png" href="/favicon-96x96.png" sizes="96x96">' +
  '<link rel="icon" type="image/png" href="/favicon-16x16.png" sizes="16x16">' +
  '<link rel="manifest" href="/manifest.json">' +
  '<meta name="msapplication-TileColor" ' +
    "content=\"#{colorTheme.sideColor}\">" +
  '<meta name="msapplication-TileImage" content="/mstile-144x144.png">' +
  '<meta name="theme-color" content="#ffffff">' +
  # The loading spinner needs some theming.
  '<style>' +
    "html{background-color:#{colorTheme.sideColor};}" +
    'body>div.main-container[data-role=\'spinner\']{' +
      "background-color:#{colorTheme.sideColor};" +
      "color:#{colorTheme.sideColor};" +
      'overflow:hidden;width:100%;height:100%}' +
    '.initial-spinner {' +
      'bottom:0;height:80px;left:0;margin:auto;position:absolute;' +
      'top:0;right:0;width:80px;' +
      '-webkit-animation: rotation .6s infinite linear;' +
      'animation: rotation .6s infinite linear;' +
      "border-left:6px solid #{colorTheme.transAsideColor};" +
      "border-right:6px solid #{colorTheme.transAsideColor};" +
      "border-bottom:6px solid #{colorTheme.transAsideColor};" +
      "border-top:6px solid #{colorTheme.asideColor};" +
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
  '<body><div class=\'main-container\' data-role=\'spinner\'>' +
    '<div class="initial-spinner"></div></div></body>'
