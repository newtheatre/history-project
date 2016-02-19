image_align = (image) ->
  container = $(image).parent()
  hAdjust = (($(image).height() - container.height()) / 2) * (2/3)
  $(image).css("top", -hAdjust)

window.ia = image_align

$(document).ready ->
  $('.person-headshot-actual').each ->
    image_align(this)
    $('.person-headshot-actual').load ->
      # Centre headshots vertically in their containers
      image_align(this)
