$(document).ready ->
  # Mobile search box
  $('#site-search-show').click ->
    $('#site-search').addClass('elem-show')
    $('#site-search-bg').removeClass('elem-hidden')
    $('#q').focus()
  $('#site-search-bg').click ->
    $('#site-search').removeClass('elem-show')
    $('#site-search-bg').addClass('elem-hidden')
