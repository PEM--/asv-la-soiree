if Meteor.isClient
  # Re-order injected tags during the initial PLT default page.
  $head = $ 'head'
  for tag in ['meta', 'link']
    $tags = $ tag
    $head.append $tags.clone()
    $tags.remove()
  # Inject lang in the html tag
  ($ 'html').attr 'lang', 'fr'
  # Create all meta informations for SEO
  $head = $ 'head'
  # Ensure that the SEO ViewModel is never instantiated twice
  @SeoViewModel = null
  # Wait for Orion's dictionary to get ready
  Tracker.autorun =>
    isDictReady = not not orion.dictionary.findOne()
    unless isDictReady
      # This case shouldn't exist, logs it if it happens
      appLog.warn 'Orion\'s dictionary isn\'t ready yet'
      return
    appLog.info 'Orion\'s dictionnary is ready. \
      Start real time modification of SEO values.'
    appLog.info "#{orion.dictionary.get 'site.title'}"
    appLog.info "#{orion.dictionary.get 'site.description'}"
    appLog.info "#{orion.dictionary.get 'analytics.google-ua'}"
    # Wait for jQuery to stabilyze
    Meteor.defer =>
      # Create or update reactive SEO data structure
      if SeoViewModel is null
        appLog.info 'SEO reactive information are set on the <head>.'
        @SeoViewModel = new ViewModel
          title: "#{orion.dictionary.get 'site.title'}"
          description: "#{orion.dictionary.get 'site.description'}"
        @SeoViewModel.bind $head
      else
        appLog.info 'Dictionary updated, changing SEO values.'
        SeoViewModel.title orion.dictionary.get 'site.title'
        SeoViewModel.description orion.dictionary.get 'site.description'

  # @TODO Change also the current Google Analytics UA

  # Removing spinner once Meteor has started up and jQuery is available.
  spinnerEl = '.main-container[data-role=\'spinner\']'
  ($ spinnerEl).css 'opacity', 0
  # @NOTE Don't use transitionEnd here as behavior of Safari and Firefox
  # are buggy when their rendering engine starts pumping new data.
  Meteor.setTimeout ->
    ($ spinnerEl).remove()
  , 300
