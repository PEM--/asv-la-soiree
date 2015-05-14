# Re-order injected tags during the initial PLT default page.
$head = $ 'head'
for tag in ['meta', 'title', 'link']
  $tags = $ tag
  $head.append $tags.clone()
  $tags.remove()
# Removing spinner once Meteor has started up
$('.main-container[data-role=\'spinner\']')
  .css 'opacity', 0
  .on TRANSITION_END_EVENT, ->
    ($ @).remove()
