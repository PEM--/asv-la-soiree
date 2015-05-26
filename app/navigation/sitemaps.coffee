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
   * @param  {Object} cursor Collection cursor.
   * @param  {Boolean} isFirstRun Flag for initial creation (false by default).
  ###
  updateSitemapOnPage = (cursor, isFirstRun = false) ->
    appLog.info if isFirstRun then 'Creating sitemap' else \
      'Page change detected. Recreating sitemap.'
    pages = pagesCursor.fetch()
    entries = _.map pages, (page) ->
      page: page.slug
      lastmod: page.createdAt
    entries.push page: '/', lastmod: orion.dictionary.get 'site.lastModified'
    sitemaps.add '/sitemap.xml', -> entries
  # Create an initial sitemap
  pagesCursor = Pages.find {}, sort: createAd: -1
  return appLog.warn 'No page found' if pagesCursor.count() is 0
  updateSitemapOnPage pagesCursor, true
  # Observe change on page in case new links are inserted
  pagesCursor.observeChanges
    added: -> updateSitemapOnPage pagesCursor
    removed: -> updateSitemapOnPage pagesCursor
    changed: -> updateSitemapOnPage pagesCursor


  # @TODO Change date of home in site map when info are changed on it
  # @TODO Store the date in the dictionnary
