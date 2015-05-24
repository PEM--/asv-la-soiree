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


# Create reactive SEO data structure
@SeoViewModel = new ViewModel 'SeoViewModel',
  title: "#{orion.dictionary.get 'site.title'}"
  description: "#{orion.dictionary.get 'site.description'}"
SeoViewModel.bind $head

# Removing spinner once Meteor has started up and jQuery is available.
spinnerEl = '.main-container[data-role=\'spinner\']'
($ spinnerEl).css 'opacity', 0
# @NOTE Don't use transitionEnd here as behavior of Safari and Firefox
# are buggy when their rendering engine starts pumping new data.
Meteor.setTimeout ->
  ($ spinnerEl).remove()
, 300

# Global variable determined at Meteor's start
Session.set 'IS_MOBILE', 'ontouchstart' of window
#Session.set 'IS_MOBILE', true
