# Stuff for /people/first_last/ pages

$(window).load ->
  $('.person-show-poster').each ->
    crop_height = $(this).height()
    image = $('img', this)
    h = image.height()
    if h < crop_height
      margin_top = (crop_height - h) / 2.5
      image.css("margin-top", margin_top)
