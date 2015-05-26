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
  ###*
   * Update the sitemaps when data changes on the Pages collection.
   * @param  {Object} cursor Collection cursor
  ###
  updateSitemapOnPage = (cursor) ->
    pages = pagesCursor.fetch()
    entries = _.map pages, (page) ->
      page: page.slug
      lastmod: page.createdAt
    entries.push page: '/', lastmod: new Date()
    sitemaps.add '/sitemap.xml', -> entries

  # @TODO Change date of home in site map when info are changed on it
  # @TODO Store the date in the dictionnary

  pagesCursor = Pages.find {}, sort: createAd: -1
  return appLog.warn 'No page found' if pagesCursor.count() is 0
  # Set the initial sitemaps
  updateSitemapOnPage pagesCursor
  # Observe change on page in case new links are inserted
  pagesCursor.observeChanges
    changed: ->
      updateSitemapOnPage @
