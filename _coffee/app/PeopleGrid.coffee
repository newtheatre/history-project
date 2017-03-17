class PeopleGrid
  constructor: (opts) ->
    @gridEl = opts.gridEl
    @scrollerEl = opts.scrollerEl
    @gridScrollEls = @gridEl.querySelectorAll('.scroll-detect')
    @gridActiveEl = null
    @windowPos = -1 # Make run on pageload

    @currentEl = null

    @enabled = true

    window.requestAnimationFrame(@update)

  update: (timestamp) =>
    # Only run if scroll has occurred
    if @windowPos == window.scrollY
      window.requestAnimationFrame(@update) if @enabled
      @windowPos = window.scrollY
      return 0
    else
      @windowPos = window.scrollY

    lastEl = @gridScrollEls[0]
    for el in @gridScrollEls
      ePosCurrent = el.getBoundingClientRect().top

      if ePosCurrent > 60
        # The previous element is the current element
        @setCurrent(lastEl) if @currentEl isnt lastEl
        found = true
        break

      lastEl = el

    # Selection of last element
    unless found
      if ePosCurrent < 60
        @setCurrent(lastEl) if @currentEl isnt lastEl

    window.requestAnimationFrame(@update) if @enabled

  setCurrent: (el) ->
    # Get sort data (A, B, C, &c)
    sort = el.dataset.sortLabel
    # Remove old active class
    old_active = @scrollerEl.querySelector('.active')
    old_active.classList.remove('active') if old_active
    # Add new active class
    new_active = @scrollerEl.querySelector("[data-sort='#{sort}']")
    new_active.classList.add('active')
    # Save current el
    @currentEl = el

  destructor: ->
    @enabled = false

document.addEventListener 'turbolinks:load', ->
  # Tear down existing
  if window.peopleGridEl
    window.peopleGridEl.destructor()
    delete window.peopleGridEl

  # Create
  peopleGridEl = document.querySelector('#pg')
  peopleScrollerEl = document.querySelector('#pgScroller')
  if peopleGridEl
    window.prodShotsGallery = new PeopleGrid
      gridEl: peopleGridEl
      scrollerEl: peopleScrollerEl
