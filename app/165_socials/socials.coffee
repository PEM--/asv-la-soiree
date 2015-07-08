if Meteor.isClient
  Template.socials.viewmodel
    shareOnFaceBook: ->
      fbUrl = 'https://www.facebook.com/sharer/sharer.php'
      window.open('https://www.facebook.com/sharer/sharer.php?u=' + encodeURIComponent(document.URL) + '&t=' + encodeURIComponent(document.URL)); return false;
