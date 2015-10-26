$(document).ready ->
  $('.person-headshot-actual').each ->
    # Centre headshots vertically in their containers
    container = $(this).parent()
    hAdjust = (($(this).height() - container.height()) / 2) * (2/3)
    $(this).css("top", -hAdjust)
