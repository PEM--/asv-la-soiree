Meteor.startup ->
  # Re-order injected tags during the initial PLT default page.
  $head = $ 'head'
  for tag in ['meta', 'title']
    $tags = $ tag
    $head.append $tags.clone()
    $tags.remove()
