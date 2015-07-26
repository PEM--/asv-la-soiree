if Meteor.isServer
  # Current favicon version
  favIconVersion = '?v=5'
  # Default PLT page
  # Minify HTML and set Meteor's asset at the end of the body
  Inject.rawModHtml 'doSomething', (html) ->
    # Spare scripts
    scripts = html.match /<script.*?>([\s\S]*?)<\/script>/g
    # Spare links
    links = html.match /<link.*">/g
    # Remove line feed and carriage return
    html = html.replace /\r?\n|\r/g, ''
    # Remove space between tags
    html = html.replace />\s* </g, '><'
    # Remove scripts
    html = html.replace /<script.*?>([\s\S]*?)<\/script>/g, ''
    # Remove links
    html = html.replace /<link.*">/g, ''
    # Insert Meteor's assets at the end of the body
    allScripts = scripts.join ''
    allLinks = links.join ''
    endBodyIdx = html.indexOf '</body>'
    html = s.insert html, endBodyIdx, allLinks + allScripts
    # Insert hight priority head assets
    headIdx = html.indexOf '<head>'
    html = s.insert html, headIdx + 6,
      # SEO:
      # - Set proper charset as soon as possible
      # - Title from Orion's dictionary with ViewModel bindings
      # - Site description from Orion's dictionary with ViewModel bindings
      # - Tell Google that it's an heavy JS app
      '<meta charset="utf-8">' +
      # Inform bots that the content is dynamically generated
      '<meta name="fragment" content="!">' +
      # SEO values
      htmlHeadInjectedContent() +
      # Force the initial scale for Android and iOS as our spinner may be
      #  distorted by their default viewport values.
      '<meta name="viewport" content="width=device-width,maximum-scale=1,' +
        'initial-scale=1,user-scalable=no">' +
      # Favicons
      '<link rel="apple-touch-icon" sizes="57x57" ' +
        "href=\"/apple-touch-icon-57x57.png#{favIconVersion}\">" +
      '<link rel="apple-touch-icon" sizes="60x60" ' +
        "href=\"/apple-touch-icon-60x60.png#{favIconVersion}\">" +
      '<link rel="apple-touch-icon" sizes="72x72" ' +
        "href=\"/apple-touch-icon-72x72.png#{favIconVersion}\">" +
      '<link rel="apple-touch-icon" sizes="76x76" ' +
        "href=\"/apple-touch-icon-76x76.png#{favIconVersion}\">" +
      '<link rel="apple-touch-icon" sizes="114x114" ' +
        "href=\"/apple-touch-icon-114x114.png#{favIconVersion}\">" +
      '<link rel="apple-touch-icon" sizes="120x120" ' +
        "href=\"/apple-touch-icon-120x120.png#{favIconVersion}\">" +
      '<link rel="apple-touch-icon" sizes="144x144" ' +
        "href=\"/apple-touch-icon-144x144.png#{favIconVersion}\">" +
      '<link rel="apple-touch-icon" sizes="152x152" ' +
        "href=\"/apple-touch-icon-152x152.png#{favIconVersion}\">" +
      '<link rel="apple-touch-icon" sizes="180x180" ' +
        "href=\"/apple-touch-icon-180x180.png#{favIconVersion}\">" +
      '<link rel="icon" type="image/png" ' +
        "href=\"/favicon-32x32.png#{favIconVersion}\" sizes=\"32x32\">" +
      '<link rel="icon" type="image/png" ' +
        "href=\"/android-chrome-192x192.png#{favIconVersion}\" " +
        'sizes=\"192x192\">' +
      '<link rel="icon" type="image/png" ' +
        "href=\"/favicon-96x96.png#{favIconVersion}\" sizes=\"96x96\">" +
      '<link rel="icon" type="image/png" ' +
        "href=\"/favicon-16x16.png#{favIconVersion}\" sizes=\"16x16\">" +
      '<!--[if IE]>' +
        '<meta http-equiv="X-UA-Compatible" content="IE=edge" />' +
      '<![endif]-->' +
      '<link rel="manifest" href="/manifest.json">' +
      '<meta name="msapplication-TileColor" ' +
        "content=\"#{ct.brandColor}\">" +
      '<meta name="msapplication-TileImage" ' +
        "content=\"/mstile-144x144.png#{favIconVersion}\">" +
      '<meta name="theme-color" content="#ffffff">' +
      # The loading spinner needs some theming.
      '<style>' +
        "html{background-color:#{ct.bgBrandColor};}" +
        'body>div.main-container[data-role=\'spinner\']{' +
          "background-color:#{ct.bgBrandColor};" +
          "color:#{ct.bgBrandColor};" +
          'overflow:hidden;width:100%;height:100%}' +
        'noscript{background:white;text-align:center;}' +
        'noscript>h1{color:red;}' +
        '.initial-spinner{' +
          'bottom:0;height:80px;left:0;margin:auto;position:absolute;' +
          'top:0;right:0;width:80px;' +
          '-webkit-animation:rotation .6s infinite linear;' +
          'animation:rotation .6s infinite linear;' +
          "border-left:6px solid #{ct.transBrandColor};" +
          "border-right:6px solid #{ct.transBrandColor};" +
          "border-bottom:6px solid #{ct.transBrandColor};" +
          "border-top:6px solid #{ct.brandColor};" +
          'border-radius:100%;' +
        '}' +
        '@-webkit-keyframes rotation{' +
          'from{-webkit-transform:rotate(0deg);}' +
          'to{-webkit-transform:rotate(359deg);}' +
        '}' +
        '@-moz-keyframes rotation{' +
          'from{-moz-transform:rotate(0deg);}' +
          'to{-moz-transform:rotate(359deg);}' +
        '}' +
        '@-o-keyframes rotation{' +
          'from{-o-transform:rotate(0deg);}' +
          'to{-o-transform:rotate(359deg);}' +
        '}' +
        '@keyframes rotation{' +
          'from{transform:rotate(0deg);}' +
          'to{transform: rotate(359deg);}' +
        '}' +
        'main[data-role=\'home\']{min-height:100vh;}' +
      '</style>'
    # Insert hight priority body assets
    bodyIdx = html.indexOf '<body>'
    html = s.insert html, bodyIdx + 6,
      # Inject noscript tag
      '<noscript>' +
        '<h1>Veuillez permettre l\'exécution de Javascript \
          pour utiliser ce site.</h1>' +
      '</noscript>' +
      # Inject a spinner for waiting complete Meteor download
      '<div class=\'main-container\' data-role=\'spinner\'>' +
        '<div class="initial-spinner"></div>' +
      '</div>' +
      # Warn user that their browser is outdated
      '<script>' +
        'var $buoop = {vs:{i:10,f:36,o:25,s:7},c:2};' +
        'function $buo_f(){' +
          'var e = document.createElement("script");' +
          'e.src = "//browser-update.org/update.min.js";' +
          'document.body.appendChild(e);' +
        '};' +
        'try {document.addEventListener("DOMContentLoaded", $buo_f,false)}' +
        'catch(e){window.attachEvent("onload", $buo_f)}' +
      '</script>' +
      # Google analytics
      '<script>' +
        '(function(i,s,o,g,r,a,m){i[\'GoogleAnalyticsObject\']=r;' +
        'i[r]=i[r]||function(){' +
          '(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();' +
          'a=s.createElement(o),m=s.getElementsByTagName(o)[0];' +
          'a.async=1;' +
          'a.src=g;' +
          'm.parentNode.insertBefore(a,m)})(window,' +
            'document,\'script\',\'//www.google-analytics.com/analytics.js\',' +
            '\'ga\');' +
        "ga('create','#{orion.dictionary.get 'analytics.google-ua'}','auto');" +
        'ga(\'send\', \'pageview\');' +
      '</script>'
    html
