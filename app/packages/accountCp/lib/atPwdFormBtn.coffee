# Simply 'inherites' helpers from AccountsTemplates
Template.atPwdFormBtn.helpers AccountsTemplates.atPwdFormBtnHelpers

Template.atPwdFormBtn.events
  'click button': (e, t) ->
    e.preventDefault()
    $button = t.$ e.target
    $button.addClass 'clicked'
    # $button.on TRANSITION_END_EVENT, ->
    #   $button
    #     .off TRANSITION_END_EVENT
    #     .removeClass 'clicked'
    #   $form = t.view.parentView.templateInstance().$ 'form'
    #   $form.submit()
    Meteor.setTimeout ->
      $button
        .off TRANSITION_END_EVENT
        .removeClass 'clicked'
      $form = t.view.parentView.templateInstance().$ 'form'
      $form.submit()
    , 300
