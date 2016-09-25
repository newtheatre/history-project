class RelativeTime
  constructor: (opts) ->
    @el = opts.el
    @render()

  format: ->
    moment(@el.dataset.date, "YYYY-MM-DD").startOf('day').fromNow()

  render: ->
    @el.innerHTML = @format()

$(document).ready ->
  relTimeEls = document.querySelectorAll('[data-date]')
  for relTimeEl in relTimeEls
    new RelativeTime
      el: relTimeEl
