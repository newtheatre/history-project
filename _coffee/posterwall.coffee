delay = (ms, func) -> setTimeout func, ms

posterwallImageBodge = ->
  # Set the images height to that of the container, will match all images to same height in a row
  $('.posterwall-poster img').each ->
    h = $(this).parent().height()
    $(this).height(h)

$(document).load ->
  posterwallImageBodge()


