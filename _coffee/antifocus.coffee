noBlur = (e) ->
  console.log "mup"
  @blur()

$(document).ready ->
  $('a').click noBlur
  $('div').click noBlur
  $('button').click noBlur
