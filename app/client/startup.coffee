# Re-order injected tags during the initial PLT default page.
$head = $ 'head'
for tag in ['meta', 'link']
  $tags = $ tag
  console.log 'Moving tags'
  console.dir $tags
  $head.append $tags.clone()
  $tags.remove()

@SeoViewModel = new ViewModel 'SeoViewModel',
  title: 'Toto'
SeoViewModel.bind ($ 'head')

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
# Create element polyfill for picture
document.createElement 'picture'
