if Meteor.isClient
  Meteor.startup ->
    # Inject lang in the html tag
    ($ 'html').attr 'lang', 'fr'
    # Removing spinner once Meteor has started up and jQuery is available.
    spinnerEl = '.main-container[data-role=\'spinner\']'
    ($ spinnerEl).css 'opacity', 0
    # @NOTE Don't use transitionEnd here as behavior of Safari and Firefox
    # are buggy when their rendering engine starts pumping new data.
    Meteor.setTimeout ->
      ($ spinnerEl).remove()
    , 300
