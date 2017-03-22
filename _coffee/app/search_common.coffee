class SiteSearch
  # The UI thread class for doing the searches

  # This object owns the search worker and is preserved between page visits (via
  # turbolinks)

  SEARCH_WORKER_URL = '/js/search_worker.js'
  SEARCH_INDEX_URL = '/feeds/search_index.json'
  SEARCH_DATA_URL = '/feeds/search.json'

  constructor: (opts) ->
    # We own the content of the search templates, this stops the DOM being
    # queried for them every time a new page is visited.
    @templateResultsHTML = document.querySelector('#search-results').innerHTML
    @templateResultsEmptyHTML = document.querySelector('#search-result-empty').innerHTML
    @templateResultHTML = document.querySelector('#search-result').innerHTML

    # Start the search worker and initialise it with the feeds for site search
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
    # Perform a search on behalf of another object. Call that object's callback
    # once complete.
    # Using an instance var as we do not expect more than one search at a time.
    @resultsCallback = callback
    @searchWorker.postMessage
      cmd: 'search'
      query: q

  onMessage: (e) =>
    # Handle search worker messages
    data = e.data
    switch (data.cmd)
      when 'ready'
        # Search worker is ready
        @isReady = true
        @readyCallback()
      when 'results'
        @resultsCallback(data.results)

# Done once on initial page ready, the site search class is maintained
# throughout a visit.
$(document).ready ->
  window.siteSearch = new SiteSearch()
