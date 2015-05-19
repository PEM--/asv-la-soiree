Meteor.startup ->
  GoogleMaps.load()

Template.map.onCreated ->
  GoogleMaps.ready 'map', (map) ->
    console.log 'Maps ready'

Template.map.helpers
  mapOptions: ->
    if GoogleMaps.loaded()
      center: new google.maps.LatLng 45.76404, 4.83566
      zoom: 8
