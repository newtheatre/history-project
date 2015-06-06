# Navigation (mainly for refreshless mode)

nthp.updateNavbar = (section) ->
  $(".site-nav .page-link").removeClass('current')
  $(".site-nav [data-current='#{section}']").addClass('current')
