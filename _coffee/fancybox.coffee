window.fancyboxOpen = false

$(document).ready ->
  $('.fancybox').fancybox
    beforeShow: ->
      window.fancyboxOpen = true
    beforeClose: ->
      window.fancyboxOpen = false
      true # Would cancel close otherwise

