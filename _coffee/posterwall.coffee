delay = (ms, func) -> setTimeout func, ms

$(document).ready ->
  delay 400, ->
    $('.posterwall-poster').each ->
      h = $('img', this).height()
      $( this ).height(h)
