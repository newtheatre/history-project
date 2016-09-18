class PeopleSearch
  SEARCH_WORKER_URL = '/js/search_worker.js'
  SEARCH_INDEX_URL = '/feeds/people_index.json'
  SEARCH_DATA_URL = '/feeds/people2.json'
  FIELDS = [
    ['people-filter-name', '']
    ['people-filter-graduated', 'graduated']
    ['people-filter-career', 'career']
    ['people-filter-course', 'course']
    ['people-filter-award', 'award']
    ['people-filter-srole', 'srole']
    ['people-filter-crole', 'crole']
  ]

  PS_FILTER_FIXED_TOP = 27
  PS_FILTER_FIXED_CLASS = 'people-index__filters--fixed'

  constructor: (opts) ->
    @enabled = true

    @psFilterEl = opts.psFilterEl
    @psResults = new PeopleResults
      psResultsEl: opts.psResultsEl

    @footerEl = document.querySelector('.site-footer')

    @searchWorker = new Worker(SEARCH_WORKER_URL)
    @searchWorker.postMessage
      cmd: 'init'
      indexUrl: SEARCH_INDEX_URL
      dataUrl: SEARCH_DATA_URL
    @searchWorker.addEventListener 'message', (e) =>
      @psResults.render(e.data)

    @bindSearchFields()

    @psFilterElOffsetTop = $(@psFilterEl).offset().top
    window.requestAnimationFrame(@update)

  destructor: ->
    @searchWorker.postMessage
      cmd: 'stop'
    @enabled = false

  bindSearchFields: ->
    @searchFields = Array()
    for field in FIELDS
      elem = document.getElementById(field[0])
      elem.addEventListener('input', @search)
      @searchFields.push [elem, field[1]]

  searchTerm: ->
    query_terms = Array()
    for field in @searchFields
      if field[1] == '' and field[0].value != ""
        query_terms.push(field[0].value)
      else if field[0].value != ""
        query_terms.push("#{field[1]}:#{field[0].value}".replace(/ /g, '_'))

    query_terms.join ' '

  search: =>
    q = @searchTerm()

    if q.length > 0
      @searchWorker.postMessage
        cmd: 'search'
        query: q
    else
      @psResults.clear()

  update: =>
    # Only run if scroll changed AND not mobile
    if (@windowPos != window.scrollY) and not isMobile()
      if window.scrollY > (@psFilterElOffsetTop - PS_FILTER_FIXED_TOP)
        @psFilterEl.classList.add(PS_FILTER_FIXED_CLASS)
      else
        @psFilterEl.classList.remove(PS_FILTER_FIXED_CLASS)

      footerOffsetTop = $(@footerEl).offset().top - window.scrollY
      filterFooterDistance = footerOffsetTop - (
        @psFilterEl.getBoundingClientRect().height + PS_FILTER_FIXED_TOP)

      if filterFooterDistance < PS_FILTER_FIXED_TOP
        @psFilterEl.style.top = "#{filterFooterDistance}px"
      else
        @psFilterEl.style.top = ""

    @windowPos = window.scrollY
    window.requestAnimationFrame(@update) if @enabled


class PeopleResults
  constructor: (opts) ->
    @psResultsEl = opts.psResultsEl
    @psEmptyTemplate = _.template(
      document.getElementById('psResultEmpty').textContent)
    @psIntro = document.getElementById('psIntro')

  clear: ->
    if @psIntro?
      @psIntro.parentNode.removeChild(@psIntro)
      delete @psIntro
    while @psResultsEl.hasChildNodes()
      @psResultsEl.removeChild(@psResultsEl.lastChild)

  render: (results) ->
    @clear()

    if results.length == 0
      @psResultsEl.innerHTML = @psEmptyTemplate()
    
    output = Array()
    for result in results
      pr = new PeopleResult(result)
      @psResultsEl.appendChild pr.render()


class PeopleResult
  TEMPLATE_RESULT = 'psResultTemplate'
  constructor: (result) ->
    @result = result
    @node = document.createElement('li')
  getTemplate: ->
    _.template document.getElementById(TEMPLATE_RESULT).textContent
  render: ->
    html = @getTemplate()
      item: @result
    @node.innerHTML = html
    return @node


$(document).ready ->
  psFilter = document.querySelector('#psFilter')
  psResults = document.querySelector('#psResults')
  if psFilter and psResults
    window.peopleSearch = new PeopleSearch
      psFilterEl: psFilter
      psResultsEl: psResults

document.addEventListener 'turbolinks:visit', ->
  if window.peopleSearch
    window.peopleSearch.destructor()
    delete window.peopleSearch
