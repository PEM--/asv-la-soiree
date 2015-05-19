Template.atInput.rendered = AccountsTemplates.atInputRendered

# Simply 'inherites' helpers from AccountsTemplates
Template.atInput.helpers AccountsTemplates.atInputHelpers
# Simply 'inherites' events from AccountsTemplates
Template.atInput.events AccountsTemplates.atInputEvents

# Simply 'inherites' helpers from AccountsTemplates
Template.atTextInput.helpers AccountsTemplates.atInputHelpers
Template.atTextInput.rendered = ->
  Meteor.setTimeout ->
    @$ 'input'
    .each (idx, el) =>
      $el = @$ el
      $el.addClass 'filled' unless $el.val().length is 0
  , 300
Template.atTextInput.events
  'focus input': (e, t) ->
    (t.$ e.target).addClass 'filled'
  'blur input': (e, t) ->
    (t.$ e.target).removeClass 'filled' if e.target.value.length is 0

# Simply 'inherites' helpers from AccountsTemplates
Template.atCheckboxInput.helpers AccountsTemplates.atInputHelpers

# Simply 'inherites' helpers from AccountsTemplates
Template.atSelectInput.helpers AccountsTemplates.atInputHelpers

# Simply 'inherites' helpers from AccountsTemplates
Template.atRadioInput.helpers AccountsTemplates.atInputHelpers

# Simply 'inherites' helpers from AccountsTemplates
Template.atHiddenInput.helpers AccountsTemplates.atInputHelpers