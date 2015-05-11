Meteor.startup ->
  # Re-order injected tags during the initial PLT default page.
  $head = $ 'head'
  for tag in ['meta', 'title']
    $tags = $ tag
    $head.append $tags.clone()
    $tags.remove()
  # @TODO Fade this out
  ($ '.initial-spinner').remove()
  Meta.setTitle \
    orion.dictionary.get 'site.title', 'ASV, la soirée'
