# Mash of History.js and jQuery XHR to create a sweet ass-navigation.

# documentHTML = (html) ->
#     result = String(html)
#     result = String(html)
#         .replace(/<\!DOCTYPE[^>]*>/i, '')
#         .replace(/<(html|head|body|title|meta|script)([\s\>])/gi, '<div class="document-$1"$2')
#         .replace(/<\/(html|head|body|title|meta|script)\>/gi, '</div>')
#     return $.trim result

nthp.pageCache = {}

$(document).ready ->
    siteUrl = 'http://'+(document.location.hostname||document.location.host)

    # Limit to internal links, we can't AJAXify external links!
    $(document).delegate 'a[href^="/"]:not(.vanilla),a[href^="'+siteUrl+'"]:not(.vanilla)', "click", (e) ->
        if localStorage.debug_mode isnt 'yes'
            e.preventDefault()
            History.pushState {}, "", this.pathname

    updatePage = (tempDOM) ->
        # Our page data object, anything that needs passing to the update process
        # should go here.
        pageData = $(tempDOM).find('#page-data').data()

        # Set page title
        document.title = $(tempDOM).find('title').text()
        # Update the nav bar
        nthp.updateNavbar pageData['current']
        # Update the report tools
        # Update the page content
        $('.content').html $(tempDOM).find('.content').html()
        # Push the pageview to Google Analytics
        # _gaq.push(['_trackPageview', State.url])

        nthp.scrollTo('body')

    History.Adapter.bind window, 'statechange', ->
        state = History.getState()

        if nthp.pageCache[state.url] isnt undefined
            console.log("#{state.url} in cache")

            updatePage(nthp.pageCache[state.url])

        else
            console.log("#{state.url} is fresh")

            Pace.track =>
                $.get state.url, (data) ->
                    tempDOM = $('<div></div>').append $.parseHTML(data)

                    nthp.pageCache[state.url] = tempDOM

                    updatePage(tempDOM)
