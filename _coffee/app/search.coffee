class SiteSearch
  # The UI thread class for doing the searches
  SEARCH_WORKER_URL = '/js/search_worker.js'
  SEARCH_INDEX_URL = '/feeds/search_index.json'
  SEARCH_DATA_URL = '/feeds/search.json'

  constructor: (opts) ->
    @templateResultsHTML = document.querySelector('#search-results').innerHTML
    @templateResultsEmptyHTML = document.querySelector('#search-result-empty').innerHTML
    @templateResultHTML = document.querySelector('#search-result').innerHTML

    @searchWorker = new Worker(SEARCH_WORKER_URL)
    @searchWorker.postMessage
      cmd: 'init'
      indexUrl: SEARCH_INDEX_URL
      dataUrl: SEARCH_DATA_URL
    @searchWorker.addEventListener 'message', @onMessage

    @isReady = false # Are we ready for user input?
    @readyCallback = null
    @resultsCallback = null

  search: (q, callback) =>
    @resultsCallback = callback
    @searchWorker.postMessage
      cmd: 'search'
      query: q

  onMessage: (e) =>
    data = e.data
    switch (data.cmd)
      when 'ready'
        # Search worker is ready
        @isReady = true
        @readyCallback()
      when 'results'
        @resultsCallback(data.results)

class SearchForm
  # Search form in-the-header
  constructor: (form) ->
    @formEl = form
    @formEl.addEventListener('submit', @onSearch)
    @inputEl = @formEl.querySelector('[data-search-input]')
    @inputEl.addEventListener 'input', debounce =>
          @onType()
    # Handle user leaving the interaction
    # @inputEl.addEventListener('blur', @onBlur)
    # Handle user return after blur
    @inputEl.addEventListener('focus', @onType)
    @resultsView = null

    if not window.siteSearch.isReady
      @normalPlaceholderText = @inputEl.placeholder
      @inputEl.placeholder = "SBY"
      window.siteSearch.readyCallback = @onReady

  onReady: (e) =>
    @inputEl.placeholder = @normalPlaceholderText

  onSearch: (e) =>
    e.preventDefault()
    if window.siteSearch.isReady
      q = @inputEl.value
      window.siteSearch.search(q, @onResult)

  onType: =>
    q = @inputEl.value
    if window.siteSearch.isReady and q.length > 0
      # Search is ready and we have a query
      window.siteSearch.search(q, @onResult)
    else if q.length == 0 and @resultsView
      # Empty get rid of results
      @resultsView.remove()
      @resultsView = null

  onResult: (results) =>
    if @resultsView
      @resultsView.render(results)
    else
      @resultsView = new SearchResultsView(@)
      @resultsView.render(results)

  onBlur: =>
    # User has clicked away, remove results
    @resultsView.remove()
    @resultsView = null


class SearchResultsView
  # Results view, has many search results, handles dealing with those results
  SITE_SEARCH_CONTAINER = '#site-search'
  constructor: (parent) ->
    @parent = parent
    @template = _.template(window.siteSearch.templateResultsHTML)
    @emptyTemplate = _.template(window.siteSearch.templateResultsEmptyHTML)
    @insert()

    Mousetrap.bind('up', @onUp)
    Mousetrap.bind('down', @onDown)
    Mousetrap.bind('enter', @onSelect)

  insert: ->
    @containerDiv = document.createElement("div")
    @containerDiv.classList.add 'dynamic-search'
    @containerDiv.innerHTML = @template()
    document.querySelector(SITE_SEARCH_CONTAINER).appendChild(@containerDiv)
    @resultsListEl = @containerDiv.querySelector('#site-search__results')

  render: (results) ->
    while (@resultsListEl.firstChild)
      @resultsListEl.removeChild(@resultsListEl.firstChild)

    # Contains all the child views (i.e. individual results)
    @resultViews = []
    # Index of the currently selected result
    @activeI = null

    if results.length > 0
      for result in results.slice(0,12)
        rV = new SearchResultView(@, result)
        @resultsListEl.appendChild(rV.node)
        @resultViews.push(rV)
    else
      @resultsListEl.innerHTML = @emptyTemplate()

  setActive: (item) ->
    if @resultViews.indexOf(item) == @activeI
      return # Skip if same
    if @activeI != null
      @resultViews[@activeI].deactivate()
    @activeI = @resultViews.indexOf(item)
    @resultViews[@activeI].activate()

  onUp: (e) =>
    e.preventDefault() # Stop moving the cursor in the text field
    if @resultViews.length > 0
      unless @activeI == null
        view = @resultViews[Math.max(0, @activeI-1)]
        @setActive(view)

  onDown: (e) =>
    e.preventDefault() # Stop moving the cursor in the text field
    if @resultViews.length > 0
      if @activeI == null
        view = @resultViews[0]
      else
        view = @resultViews[Math.min(@resultViews.length-1, @activeI+1)]
      @setActive(view)

  onSelect: (e) =>
    unless @activeI == null
      e.preventDefault() # Don't submit the form
      @resultViews[@activeI].go()

  remove: ->
    document.querySelector(SITE_SEARCH_CONTAINER).removeChild(@containerDiv)
    Mousetrap.unbind('up')
    Mousetrap.unbind('down')


class SearchResultView
  # An individual search result, child of SearchResultsView
  CLASS_LI = 'dynamic-search__result'
  CLASS_ACTIVE = '--active'
  constructor: (parent, result) ->
    @parent = parent
    @template = _.template(window.siteSearch.templateResultHTML)
    # Setup element
    @render(result)

  render: (result) ->
    @node = document.createElement('li')
    @node.classList.add CLASS_LI
    @node.innerHTML = @template
      item: result
    @anchorEl = @node.querySelector('a')
    @anchorEl.addEventListener('mousedown', @onClick)
    @anchorEl.addEventListener 'mouseenter', =>
      @parent.setActive(@)

  activate: () =>
    @anchorEl.classList.add CLASS_ACTIVE

  deactivate: () =>
    @anchorEl.classList.remove CLASS_ACTIVE

  onClick: (e) =>
    # Prevents blurring of the search field which would destroy the results view
    e.preventDefault()

  go: ->
    # Navigate to this result
    Turbolinks.visit(@anchorEl.href)


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


# Done once on initial page ready, the site search class is maintained
# throughout a visit.
$(document).ready ->
  window.siteSearch = new SiteSearch()

# On every page nav
document.addEventListener 'turbolinks:load', ->
  if $('body').hasClass 'search'
    loadIndex()
    urlQ = getUrlParameter('q')
    if urlQ != null
      $('#q').val urlQ

  searchForm = document.querySelector('[data-search-form]')
  if searchForm
    window.searchForm = new SearchForm(searchForm)
