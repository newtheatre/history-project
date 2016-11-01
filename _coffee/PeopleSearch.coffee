class PeopleSearch
  SEARCH_WORKER_URL = '/js/search_worker.js'
  SEARCH_INDEX_URL = '/feeds/people_index.json'
  SEARCH_DATA_URL = '/feeds/people.json'
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
  PS_MORE_TOGGLE_CLASS = 'people-index__filters__more--open'
  PS_TOGGLE_TOGGLE_CLASS = 'people-index__filters__toggle--open'
  PS_BODY_PUSH_CLASS = 'people-index--push'

  constructor: (opts) ->
    @enabled = true

    @psFilterEl = opts.psFilterEl
    @psMoreEl = @psFilterEl.querySelector('#psMore')
    @psMoreToggleEl = @psFilterEl.querySelector('#psMoreToggle')
    @psBodyEl = opts.psBodyEl
    @psResults = new PeopleResults
      psResultsEl: opts.psResultsEl
    @footerEl = document.querySelector('.site-footer')

    @moreIsOpen = false
    @scrollIsFixed = false

    @searchWorker = new Worker(SEARCH_WORKER_URL)
    @searchWorker.postMessage
      cmd: 'init'
      indexUrl: SEARCH_INDEX_URL
      dataUrl: SEARCH_DATA_URL
    @searchWorker.addEventListener 'message', @onMessage

    @bindSearchFields()

    @psMoreToggleEl.addEventListener('click', @toggleMore)

    @psFilterElOffsetTop = $(@psFilterEl).offset().top
    @psFilterHeight = @psFilterEl.offsetHeight
    window.requestAnimationFrame(@update)

  destructor: ->
    @searchWorker.postMessage
      cmd: 'stop'
    @enabled = false

  bindSearchFields: ->
    @searchFields = Array()
    for field in FIELDS
      elem = document.getElementById(field[0])
      if FIELDS.indexOf(field) == 0
        elem.addEventListener 'input', debounce =>
          @onSearch()
      else
        elem.addEventListener('change', @onSearch)
      @searchFields.push [elem, field[1]]

  searchTerm: ->
    query_terms = Array()
    for field in @searchFields
      if field[1] == '' and field[0].value != ""
        query_terms.push(field[0].value)
      else if field[0].value != ""
        query_terms.push("#{field[1]}:#{field[0].value}".replace(/ /g, '_'))

    query_terms.join ' '

  onSearch: =>
    # Event listener for field changes
    q = @searchTerm()

    if q.length > 0
      @searchWorker.postMessage
        cmd: 'search'
        query: q
    else
      @psResults.clear()

  onMessage: (e) =>
    data = e.data
    switch (data.cmd)
      when 'ready'
        # Search worker is ready
        $( @searchFields[0][0] ).attr('placeholder','')
      when 'results'
        @psResults.render(data.results)

  toggleMore: =>
    # Open/close the 'more' drawer, applicable to mobile
    @moreIsOpen = !@moreIsOpen
    @psMoreEl.classList.toggle(PS_MORE_TOGGLE_CLASS)
    @psBodyEl.classList.toggle(PS_BODY_PUSH_CLASS) if @scrollIsFixed
    @psMoreToggleEl.classList.toggle(PS_TOGGLE_TOGGLE_CLASS)

  update: =>
    # Only run if scroll changed AND not mobile
    if (@windowPos != window.scrollY)
      # No top gap on mobile between header and filter box
      if isMobile()
        top_limit = @psFilterElOffsetTop
      else
        top_limit = @psFilterElOffsetTop - PS_FILTER_FIXED_TOP

      # If beyond this limit, add fixed class, otherwise remove
      # Toggle action
      if (window.scrollY > top_limit) and !@scrollIsFixed
        @scrollIsFixed = true
        @psFilterEl.classList.add(PS_FILTER_FIXED_CLASS)
        @psBodyEl.style.paddingTop = "#{@psFilterHeight + 6}px" if isMobile()
        if isMobile() and @moreIsOpen
          # http://stackoverflow.com/a/16575811/1345360
          @psBodyEl.classList.add('noTransition')
          @psBodyEl.classList.add(PS_BODY_PUSH_CLASS)
          @psBodyEl.offsetHeight
          @psBodyEl.classList.remove('noTransition')
      else if !(window.scrollY > top_limit) and @scrollIsFixed
        @scrollIsFixed = false
        @psFilterEl.classList.remove(PS_FILTER_FIXED_CLASS)
        @psBodyEl.style.paddingTop = "" if isMobile()
        if isMobile()
          # http://stackoverflow.com/a/16575811/1345360
          @psBodyEl.classList.add('noTransition')
          @psBodyEl.classList.remove(PS_BODY_PUSH_CLASS)
          @psBodyEl.offsetHeight
          @psBodyEl.classList.remove('noTransition')

      # Stop the scroll following when we hit the footer
      # Continious action
      footerOffsetTop = $(@footerEl).offset().top - window.scrollY
      filterFooterDistance = footerOffsetTop - (
        @psFilterEl.getBoundingClientRect().height + PS_FILTER_FIXED_TOP)

      if (filterFooterDistance < PS_FILTER_FIXED_TOP) and !isMobile()
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
  psBody = document.querySelector('#psBody')
  psResults = document.querySelector('#psResults')

  if psFilter and psResults
    window.peopleSearch = new PeopleSearch
      psFilterEl: psFilter
      psBodyEl: psBody
      psResultsEl: psResults

document.addEventListener 'turbolinks:visit', ->
  if window.peopleSearch
    window.peopleSearch.destructor()
    delete window.peopleSearch
