# Stuff for show pages photo gallery

mobile_max_images = 4
desktop_max_images = 12

# Show / hide toggle
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

    # Load all images
    $('.lazy-image').each ->
      $(this).attr("src", $(this).data("lazy-src"))

# Delay image loading
$(window).load ->
  window.isMobile = $('.gallery-control').css('display') == "none"

  $('.lazy-image').each ->
    # Show (4) only on mobile and (12) on desktop, definitions at top of file
    if window.isMobile and $(this).data('image-count') < mobile_max_images
      $(this).attr("src", $(this).data("lazy-src"))
    if not window.isMobile and $(this).data('image-count') < desktop_max_images
      $(this).attr("src", $(this).data("lazy-src"))

    $(this).load ->
      # Centre photos vertically in their containers
      container = $(this).parent().parent()
      hAdjust = (($(this).height() - container.height()) / 2) * (2/3)
      $(this).css("top", -hAdjust)
