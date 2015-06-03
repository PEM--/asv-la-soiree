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
   * Update the sitemaps when data changes on the BasicPages collection.
   * @param  {Object} cursor Collection cursor.
   * @param  {Boolean} isFirstRun Flag for initial creation (false by default).
  ###
  updateSitemapOnPage = (cursor, isFirstRun = false) ->
    appLog.info if isFirstRun then 'Creating sitemap' else \
      'Page or dictionary change detected. Recreating sitemap.'
    pages = pagesCursor.fetch()
    entries = _.map pages, (page) ->
      page: page.slug
      lastmod: page.createdAt
    entries.push page: '/', lastmod: orion.dictionary.get 'site.lastModified'
    sitemaps.add '/sitemap.xml', -> entries
  # Create an initial sitemap
  pagesCursor = BasicPages.find {}, sort: createAd: -1
  return appLog.warn 'No page found' if pagesCursor.count() is 0
  updateSitemapOnPage pagesCursor, true
  # Observe change on page in case new links are inserted, removed or modified.
  pagesCursor.observe (changes) ->
    updateSitemapOnPage pagesCursor
  # Observe changes on the dictionary in case the date for forcing
  #  a new sitemap has changed.
  dictionaryCursor = orion.dictionary.find()
  dictionaryCursor.observeChanges
    # @NOTE The dictionary always exists and is a collection with
    #  a single value. Items are never added or removed. Only its single
    #  value content may change.
    changed: -> updateSitemapOnPage pagesCursor
