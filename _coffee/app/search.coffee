# If search page

INDEX_URL = '/feeds/search_index.json'
REVERSE_INDEX_URL = '/feeds/search_index_reverse.json'

indexReady = ->
  # Must wait for this function call before running searches
  configureWindow()

configureWindow = ->
  sView = new SearchResultView

  # DEBUG GLOBALS
  window.sView = sView
  # window.reverse_index = reverse_index
  # window.index = index

  # Search based on url param from previous page
  urlQ = getUrlParameter('q')
  if urlQ != null
    sView.search urlQ
    $('#q').val urlQ
  else
    sView.renderBlank()

  # Focus to search field
  $('#q').focus()

  # Bind to keyup events on the search box
  $('#q').keyup debounce ->
    if $(this).val().length < 2
      return sView.renderBlank()

    query = $(this).val()
    sView.search(query)

index = new Object
reverse_index = new Object

loadIndex = ->
  # Populate the lunr index with page data
  console.time 'loadIndex'
  $.get INDEX_URL, (data) ->
    index = lunr.Index.load(data)
    $.get REVERSE_INDEX_URL, (data) ->
      reverse_index = data
      # Search is ready
      indexReady()
    , 'json'
  , 'json'
  console.timeEnd 'loadIndex'

doSearch = (query) ->
  # The actual search code. Take query, return useful array.
  lunr_results = index.search(query)

  results = new Array
  lunr_results.forEach (item) ->
    results.push reverse_index[ item['ref'] ]

  return results

window.doSearch = doSearch

class SearchResultView
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

# Setup
$(document).ready ->
  if $('body').hasClass 'search'
    loadIndex()
    urlQ = getUrlParameter('q')
    if urlQ != null
      $('#q').val urlQ
