Meteor.startup ->
  GoogleMaps.load()

Template.map.onCreated ->
  GoogleMaps.ready 'map', (map) ->
    console.log 'Maps ready'

Template.map.helpers
  mapOptions: ->
    if GoogleMaps.loaded()
      center: new google.maps.LatLng 45.76404, 4.83566
      zoom: 14
      panControl: false
      zoomControl: false
      mapTypeControl: false
      scaleControl: false
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
          stylers: [
            { color: ct.textColor }
            { weight: 5.0 }
          ]
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
          elementType: 'geometry'
          stylers: [{ color: ct.bgColor }]
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
          stylers: [
            { visibility: 'on' }
            { weight: 3.0 }
          ]
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
          stylers: [ { visibility: 'off' } ]
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
          stylers: [
            { color: ct.highwayColor }
            { lightness: 60 }
            { weight: 1.5 }
          ]
        }
        {
          featureType: 'road.highway'
          elementType: 'geometry.stroke'
          stylers: [ { color: ct.highwayColor } ]
        }
        {
          featureType: 'road.arterial'
          elementType: 'geometry.fill'
          stylers: [
            { color: ct.roadColor}
            { lightness: 60 }
            { weight: 0.2 }
          ]
        }
        {
          featureType: 'road.arterial'
          elementType: 'geometry.stroke'
          stylers: [
            { color: ct.roadColor }
            { weight: 0.2 }
          ]
        }
        {
          featureType: 'road.arterial'
          elementType: 'labels'
          stylers: [{ visibility: 'off' }]
        }

        {
          featureType: 'road.local'
          elementType: 'geometry'
          stylers: [{ visibility: 'off' }]
        }
        {
          featureType: 'transit'
          elementType: 'geometry.fill'
          stylers: [
            { color: ct.textColor }
            { lightness: 40 }
            { weight: 2.0 }
          ]
        }
        {
          featureType: 'transit'
          elementType: 'geometry.stroke'
          stylers: [{ color: ct.textColor }]
        }
        {
          featureType: 'transit.station.rail'
          elementType: 'all'
          stylers: [ { visibility: 'on' } ]
        }
        {
          featureType: 'water'
          elementType: 'geometry.fill'
          stylers: [
            { color: ct.waterColor }
            { lightness: 60 }
          ]
        }
        {
          featureType: 'water'
          elementType: 'geometry.stroke'
          stylers: [{ color: ct.waterColor }]
        }
      ]
