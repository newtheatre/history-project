class SearchResultViewXYZ
  TEMPLATE_RESULT = '#search-result'
  TEMPLATE_EMPTY = '#search-message-empty'
  RENDER_TO = '[data-search-results]'

  getSingleTemplate: ->
    _.template $(TEMPLATE_RESULT).html()

  search: (query) ->
    @query = query
    @render()

  render: ->
    results = doSearch(@query)

    if results.length > 0
      @renderResults(results)
    else
      @renderEmpty()

  renderResults: (results) ->
    singleTemplate = @getSingleTemplate()
    results_html = []
    results.forEach (result) ->
      results_html.push singleTemplate
        item: result

    $(RENDER_TO).html results_html

  renderEmpty: ->
    template = _.template $(TEMPLATE_EMPTY).html()
    html = template
      query: @query
    $(RENDER_TO).html html

  renderBlank: ->
    $(RENDER_TO).html '<!-- BLANK -->'




# On every page nav
document.addEventListener 'turbolinks:load', ->
  if $('body').hasClass 'search'
    loadIndex()
    urlQ = getUrlParameter('q')
    if urlQ != null
      $('#q').val urlQ
