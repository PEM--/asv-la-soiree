if Meteor.isClient
  myFade = ->
    (options) ->
      options = _.extend
        duration: 300
        easing: 'ease-in-out'
      , options
      return {
        insertElement: (node, next, done) ->
          $node = $ node
          $node
            .css 'opacity', 0
            .insertBefore next
            #.scrollTop Session.get 'scrollPos'
            .velocity
              opacity: [1, 0]
          ,
            easing: options.easing
            duration: options.duration
            queue: false
            complete: done
        removeElement: (node, done) ->
          $node = $ node
          $node
            .velocity
              opacity: [0]
            ,
              duration: options.duration
              easing: options.easing
              complete: ->
                $node.remove()
                done()
      }

  Momentum.registerPlugin 'myFade', myFade()
