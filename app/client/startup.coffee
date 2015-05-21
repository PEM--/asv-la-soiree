# Re-order injected tags during the initial PLT default page.
$head = $ 'head'
for tag in ['meta', 'title', 'link']
  $tags = $ tag
  $head.append $tags.clone()
  $tags.remove()
# Removing spinner once Meteor has started up and jQuery is available.
spinnerEl = '.main-container[data-role=\'spinner\']'
($ spinnerEl).css 'opacity', 0
# @NOTE Don't use transitionEnd here as behavior of Safari and Firefox
# are buggy when their rendering engine starts pumping new data.
Meteor.setTimeout ->
  ($ spinnerEl).remove()
, 300

# Detect if it's a mobile or tablet
@isTouchDevice() ->
  (('ontouchstart' in window) or (navigator.MaxTouchPoints > 0) or
  (navigator.msMaxTouchPoints > 0))
