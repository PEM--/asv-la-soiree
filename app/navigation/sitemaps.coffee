# https://support.google.com/webmasters/answer/183668?hl=fr
# required: page
# optional: lastmod, changefreq, priority, xhtmlLinks, images, videos
# https://support.google.com/webmasters/answer/178636?hl=en
# {
#   page: '/pageWithViedeoAndImages'
#   images: [
#     { loc: '/myImg.jpg' }         # Only loc is required
#     { loc: '/myOtherImg.jpg'       # Below properties are optional
#       caption: "..", geo_location: "..", title: "..", license: ".."}
#   ]
#   videos: [
#     { loc: '/myVideo.jpg', },      // Only loc is required
#     { loc: '/myOtherVideo.jpg',    // Below properties are optional
#       thumbnail_loc: "..", title: "..", description: ".." etc }
#   ]
# }
# https://support.google.com/webmasters/answer/2620865?hl=en
# {
#   page: 'lang/english', xhtmlLinks: [
#     { rel: 'alternate', hreflang: 'de', href: '/lang/deutsch' }
#     { rel: 'alternate', hreflang: 'de-ch', href: '/lang/schweiz-deutsch' }
#     { rel: 'alternate', hreflang: 'en', href: '/lang/english' }
#   ]
# }
if Meteor.isServer
  sitemaps.add '/sitemap.xml', -> [ { page: '/', lastmod: new Date() }]
