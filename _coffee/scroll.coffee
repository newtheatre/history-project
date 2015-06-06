nthp.scrollTo = (element) ->
  target = $(element)
  if target.length
    distance = Math.abs(target.offset().top - $( document ).scrollTop()) / 3
    speed = Math.round(distance / 2)
    $('html,body').animate
      scrollTop: target.offset().top
    , speed

$('a[href*=#]:not([href=#])').click ->
  if location.pathname.replace(/^\//,'') is this.pathname.replace(/^\//,'') and location.hostname is this.hostname
    target = $(this.hash)
    nthp.scrollTo(target)
    return false
