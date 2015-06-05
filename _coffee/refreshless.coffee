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
        e.preventDefault()
        History.pushState {}, "", this.pathname

    History.Adapter.bind window, 'statechange', ->
        state = History.getState()
        $.get state.url, (data) ->
            tempDOM = $('<div></div>').append $.parseHTML(data)
            console.log $(tempDOM).find('title').text()
            window.x = tempDOM
            document.title = $(tempDOM).find('title').text()
            $('.content').html $(tempDOM).find('.content').html()
            # _gaq.push(['_trackPageview', State.url])
