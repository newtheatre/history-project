class SearchFullView
  # Full search engine view, handles the form and the results
  TEMPLATE_EMPTY = '#search-message-empty'
  RENDER_TO = '[data-search-results]'
  RESULT_MAX = 50

  constructor: (form) ->
    @formEl = form
    @formEl.addEventListener('submit', @onSearch)
    # Search field
    @inputEl = @formEl.querySelector('[data-search-input]')
    @inputEl.addEventListener 'input', debounce =>
      @onType()

    @containerEl = document.querySelector(RENDER_TO)

    # Empty template
    @emptyTemplate = _.template(document.querySelector(TEMPLATE_EMPTY).innerHTML)

    # Hold off unless search is ready
    if not window.siteSearch.isReady
      window.siteSearch.readyCallback = @onReady
    else
      @onReady()

  onReady: (e) =>
    # Clear loading spinner
    @containerEl.innerHTML = ''
    # Create element for handling results and add to DOM
    @resultsListEl = document.createElement('ul')
    @containerEl.appendChild(@resultsListEl)
    # Set initial search
    initialQuery = getUrlParameter('q')
    if initialQuery
      @inputEl.value = initialQuery
      window.siteSearch.search(initialQuery, @onResult)

  onSearch: (e) =>
    # Called when the search field is submitted (press enter)
    # SearchHeadResultView overrides the 'enter' button handler when a result is
    # selected.
    e.preventDefault()
    if window.siteSearch.isReady
      q = @inputEl.value
      window.siteSearch.search(q, @onResult)

  onType: =>
    # Called (de-bounced) when the user types into the search field. Does a
    # search to yield instant results.
    q = @inputEl.value
    if window.siteSearch.isReady and q.length > 0
      # Search is ready and we have a query
      window.siteSearch.search(q, @onResult)
      # Replace the URL with an updated one for new query. Fixes #174.
      history.replaceState(history.state, document.title, "/search/?q=#{q}" )
    else if q.length == 0
      # User has cleared the search field, get rid of results
      @clearDown()

  onResult: (results) =>
    # Callback for search results
    @clearDown()

    @resultViews = []

    if results.length > 0
      # We have results, render them. Limit the number of results shown
      for result in results.slice(0, RESULT_MAX)
        rV = new SearchFullResultView(@, result)
        @resultsListEl.appendChild(rV.node)
        @resultViews.push(rV)
    else
      # No results, render the empty template
      @resultsListEl.innerHTML = @emptyTemplate
        query: @inputEl.value

  clearDown: ->
    while (@resultsListEl.firstChild)
      @resultsListEl.removeChild(@resultsListEl.firstChild)


class SearchFullResultView
  # An individual search result, child of SearchFullResultsView
  TEMPLATE_RESULT = '#search-result'

  constructor: (parent, result) ->
    @parent = parent
    @result = result
    @template = _.template(document.querySelector(TEMPLATE_RESULT).innerHTML)
    @render()

  render: ->
    # This view is only rendered once. Setup @node. We do not insert @node into
    # the DOM, that's the responsibility of this view's parent.
    @node = document.createElement('li')
    @node.innerHTML = @template
      item: @result
    @anchorEl = @node.querySelector('a')


# On every page nav
document.addEventListener 'turbolinks:load', ->
  searchForm = document.querySelector('#site-search-full')
  if searchForm
    window.searchFullView = new SearchFullView(searchForm)
