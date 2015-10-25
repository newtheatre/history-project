$("[data-show-photos-toggle]").click (e) ->
  e.preventDefault()
  gallery = $('.show-photos')
  show_label = $('[data-show-label]')
  hide_label = $('[data-hide-label]')

  if $('.show-photos').hasClass('toggle-show')
    # Is open, close
    gallery.removeClass('toggle-show')
    gallery.css("max-height", "")
    hide_label.hide()
    show_label.show()
  else
    # Is closed, open
    gallery.addClass('toggle-show')
    gallery.css("max-height", gallery[0].scrollHeight)
    hide_label.show()
    show_label.hide()

