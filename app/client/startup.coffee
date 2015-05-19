# Re-order injected tags during the initial PLT default page.
$head = $ 'head'
for tag in ['meta', 'title', 'link']
  $tags = $ tag
  $head.append $tags.clone()
  $tags.remove()
# Removing spinner once Meteor has started up and jQuery is available
console.log 'Removing spinner'
spinnerEl = '.main-container[data-role=\'spinner\']'
$ spinnerEl
  .css 'opacity', 0
  .on TRANSITION_END_EVENT, ->
    ($ spinnerEl).remove()
    console.log 'Spinner removed'
