# Mash of History.js and jQuery XHR to create a sweet ass-navigation.

documentHTML = (html) ->
    result = String(html)
    result = String(html)
        .replace(/<\!DOCTYPE[^>]*>/i, '')
        .replace(/<(html|head|body|title|meta|script)([\s\>])/gi, '<div class="document-$1"$2')
        .replace(/<\/(html|head|body|title|meta|script)\>/gi, '</div>')
    return $.trim result

$(document).ready ->
    siteUrl = 'http://'+(document.location.hostname||document.location.host)

    # Limit to internal links, we can't AJAXify external links!
    $(document).delegate 'a[href^="/"],a[href^="'+siteUrl+'"]', "click", (e) ->
        if localStorage.debug_mode isnt 'yes'
            e.preventDefault()
            History.pushState {}, "", this.pathname

    History.Adapter.bind window, 'statechange', ->
        state = History.getState()
        $.get state.url, (data) ->
            tempDOM = $('<div></div>').append $.parseHTML(data)
            pageData = $(tempDOM).find('#page-data').data()
            nthp.tempDOM = tempDOM # Debug

            # Set page title
            document.title = $(tempDOM).find('title').text()

            # Update the nav bar
            nthp.updateNavbar pageData['current']

            # Update the report tools
            console.log('NYI Debug tools')

            # Update the page content
            $('.content').html $(tempDOM).find('.content').html()

            # Push the pageview to Google Analytics
            # _gaq.push(['_trackPageview', State.url])
