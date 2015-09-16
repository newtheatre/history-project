# If search page

JSON_FEED_URL = '/feeds/search.json'
TEMPLATE_RESULT = '#search-result'
TEMPLATE_EMPTY = '#search-message-empty'
RENDER_TO = '[data-search-results]'

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
  urlQ = window.getUrlParameter('q')
  sView.search urlQ
  $('#q').val urlQ

  # Bind to keyup events on the search box
  $('#q').keyup debounce ->
    if $(this).val().length < 2
      return sView.renderBlank()

    query = $(this).val()
    sView.search(query)

index = lunr ->
  @field 'title',
    boost: 10
  @field 'body'
  @field 'keywords',
    boost: 2
  @field 'playwright',
    boost: 2
  @field 'cast',
    boost: 5
  @field 'crew',
    boost: 5
  @ref 'url'

reverse_index = new Object

populateIndex = (data) ->
  # Populate the lunr index with page data
  console.time 'populateIndex'
  data.forEach (item) ->
    reverse_index[ item['link'] ] = item
    index.add
      title: item['title']
      body: item['content']
      playwright: item['playwright']
      cast: item['cast']
      crew: item['crew']
      url: item['link']
  console.timeEnd 'populateIndex'

  indexReady()

doSearch = (query) ->
  # The actual search code. Take query, return useful array.
  lunr_results = index.search(query)

  results = new Array
  lunr_results.forEach (item) ->
    results.push reverse_index[ item['ref'] ]

  return results

window.doSearch = doSearch

class SearchResultView
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
    $.get JSON_FEED_URL, populateIndex, 'json'
