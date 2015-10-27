window.fancyboxOpen = false

$(document).ready ->
  $('.fancybox').fancybox
    padding: 0
    beforeShow: ->
      window.fancyboxOpen = true
    beforeClose: ->
      window.fancyboxOpen = false
      true # Would cancel close otherwise

