Meteor.startup ->
  GoogleMaps.load()

Template.map.onCreated ->
  GoogleMaps.ready 'map', (map) ->
    console.log 'Maps ready'

Template.map.helpers
  mapOptions: ->
    if GoogleMaps.loaded()
      center: new google.maps.LatLng 45.76404, 4.83566
      zoom: 13
      panControl: false
      zoomControl: false
      mapTypeControl: false
      scaleControl: true
      streetViewControl: false
      overviewMapControl: false
      styles: [
        {
          featureType: 'all'
          elementType: 'geometry'
          stylers: [ { visibility: 'on' } ]
        }
        {
          featureType: 'all'
          elementType: 'labels'
          stylers: [ { visibility: 'on' } ]
        }
        {
          featureType: 'all'
          elementType: 'labels.text'
          stylers: [ { visibility: 'on' } ]
        }
        {
          featureType: 'all'
          elementType: 'labels.text.fill'
          stylers: [{ color: ct.textColor }]
        }
        {
          featureType: 'all'
          elementType: 'labels.text.stroke'
          stylers: [{ color: ct.bgColor }]
        }
        {
          featureType: 'all'
          elementType: 'labels.icon'
          stylers: [ { visibility: 'off' } ]
        }
        {
          featureType: 'administrative'
          elementType: 'geometry.fill'
          stylers: [{ color: ct.brandColor }]
        }
        {
          featureType: 'administrative'
          elementType: 'geometry.stroke'
          stylers: [
            { color: ct.brandColor }
          ]
        }
        {
          featureType: 'administrative.country'
          elementType: 'all'
          stylers: [ { visibility: 'off' } ]
        }
        {
          featureType: 'administrative.province'
          elementType: 'all'
          stylers: [ { visibility: 'off' } ]
        }
        {
          featureType: 'administrative.province'
          elementType: 'geometry'
          stylers: [ { visibility: 'off' } ]
        }
        {
          featureType: 'administrative.locality'
          elementType: 'all'
          stylers: [ { visibility: 'on' } ]
        }
        {
          featureType: 'administrative.locality'
          elementType: 'geometry'
          stylers: [ { visibility: 'off' } ]
        }
        {
          featureType: 'administrative.neighborhood'
          elementType: 'all'
          stylers: [ { visibility: 'off' } ]
        }
        {
          featureType: 'administrative.neighborhood'
          elementType: 'geometry'
          stylers: [ { visibility: 'off' } ]
        }
        {
          featureType: 'administrative.land_parcel'
          elementType: 'geometry'
          stylers: [{ color: ct.grassColor }]
        }
        {
          featureType: 'landscape'
          elementType: 'geometry'
          stylers: [{ color: ct.bgColor }]
        }
        {
          featureType: 'poi'
          elementType: 'geometry'
          stylers: [{ color: ct.bgColor }]
        }
        {
          featureType: 'poi.park'
          elementType: 'geometry'
          stylers: [{ color: ct.grassColor }]
        }
        {
          featureType: 'road.highway'
          elementType: 'geometry.fill'
          stylers: [ { color: ct.highwayColor }]
        }
        {
          featureType: 'road.highway'
          elementType: 'geometry.stroke'
          stylers: [ { color: ct.highwayColor, weight: 1.2 } ]
        }
        {
          featureType: 'road.arterial'
          elementType: 'geometry'
          stylers: [{ color: ct.roadColor }]
        }
        {
          featureType: 'road.local'
          elementType: 'geometry'
          stylers: [{ visibility: 'off' }]
        }
        {
          featureType: 'transit'
          elementType: 'geometry'
          stylers: [{ color: ct.textColor }]
        }
        {
          featureType: 'water'
          elementType: 'geometry'
          stylers: [{ color: ct.waterColor }]
        }
      ]
