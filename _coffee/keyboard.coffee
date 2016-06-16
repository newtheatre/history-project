bindArrows = ->
  Mousetrap.bind 'left', ->
    if jekyll_page_previous? and not window.disable_keyboard_nav
      Turbolinks.visit(jekyll_page_previous)

  Mousetrap.bind 'right', ->
    if jekyll_page_next? and not window.disable_keyboard_nav
      Turbolinks.visit(jekyll_page_next)

# Mousetrap.bind 'up', ->
#   if 'jekyll_page_up' of window
#     window.location.href = jekyll_page_up

Mousetrap.bind 'e d i t o r', ->
  if localStorage.debug_mode is "yes"
    # Disable
    localStorage.debug_mode = "no"
    $('[data-debug-toggle]').hide()
  else
    # Enable
    localStorage.debug_mode = "yes"
    $('[data-debug-toggle]').show()

window.disable_keyboard_nav = false

$(window).load ->
  # DO NOT DO ON EVERY TURBONAV
  if localStorage.debug_mode is "yes"
    $('[data-debug-toggle]').show()

  bindArrows()

document.addEventListener 'turbolinks:visit', ->
  window.jekyll_page_up = null
  window.jekyll_page_previous = null
  window.jekyll_page_next = null
