class LightboxGallery
  constructor: (galleryEm) ->
    @galleryEm = galleryEm
    @galleryLinks = galleryEm.querySelectorAll('.lightbox-link')

    for link in @galleryLinks
      link.addEventListener("click", @imageClick)

  imageClick: (ev) =>
    ev.preventDefault()
    window.ev = ev
    # Get image index in gallery
    i = @getLinkIndex ev.path[1]

    @lightbox = new Lightbox(@, i)

  getLinkIndex: (elem) ->
    # Given a link return it's index in the galleryLinks array
    for link, i in @galleryLinks
      if elem == link
        return i

  deleteLightbox: =>
    delete @lightbox

class Lightbox
  constructor: (lightboxGallery, i) ->
    @lightboxGallery = lightboxGallery
    @i = i

    # Blur page
    @blur = document.getElementById('lightbox-blur')
    @blur.classList.add('lightbox-blur--show')
    # Click on blue to close lightbox
    @blur.addEventListener('click', @close)

    # Add lightbox
    @addElement()
    @changeImage(i)

    # Keyboard bindings
    Mousetrap.unbind('left')
    Mousetrap.bind('left', @prevImage)
    Mousetrap.unbind('right')
    Mousetrap.bind('right', @nextImage)
    Mousetrap.bind('esc', @close)
    # Weird cases where unbinding global not working, extra safety
    window.disable_keyboard_nav = true

    # Freeze scrolling
    @scrollTop = document.body.scrollTop
    document.body.style.position = "fixed"
    document.body.style.top = "-#{@scrollTop}px"

  addElement: ->
    @lb = document.createElement('div')
    @lb.classList.add('lightbox-box')
    @lb.innerHTML = """
    <div class="lightbox-box__inner">
      <div title="Previous" class="lightbox-box__prev">
        <i class="ion-chevron-left"></i>
      </div>
      <div title="Next" class="lightbox-box__next">
        <i class="ion-chevron-right"></i>
      </div>
      <div title="Close" class="lightbox-box__close">
        <i class="ion-close-circled"></i>
      </div>
      <div class="lightbox-box__load">
        <i class="ion-load-c"></i>
      </div>
      <img class="lightbox-box__image" src="" alt="" />
    </div>
    """
    document.body.appendChild(@lb)

    prevEl = @lb.querySelector('.lightbox-box__prev')
    nextEl = @lb.querySelector('.lightbox-box__next')
    closeEl = @lb.querySelector('.lightbox-box__close')

    prevEl.addEventListener('click', @prevImage)
    nextEl.addEventListener('click', @nextImage)
    closeEl.addEventListener('click', @close)

    # Save ref to load spinner
    @loadSpinnerEl = @lb.querySelector('.lightbox-box__load')
    @imageEl = @lb.querySelector('.lightbox-box__image')

    # Add load complete event handler
    @imageEl.addEventListener('load', @imageLoaded)

    # Remove L&R if single image
    if @lightboxGallery.galleryLinks.length == 1
      prevEl.remove()
      nextEl.remove()

  nextImage: =>
    if (@i + 1) < @lightboxGallery.galleryLinks.length
      @changeImage(@i + 1)
    else
      # Wrap around
      @changeImage(0)

  prevImage: =>
    if (@i - 1) >= 0
      @changeImage(@i - 1)
    else
      # Loop around
      @changeImage(@lightboxGallery.galleryLinks.length - 1)

  changeImage: (i) ->
    @loadSpinnerEl.classList.add('lightbox-box__load--show')
    @imageEl.classList.add('lightbox-box__image--load')
    @imageEl.src = @lightboxGallery.galleryLinks[i].href
    @i = i

  imageLoaded: (ev) =>
    # Image load has complete, hide spinner and fade in image
    @loadSpinnerEl.classList.remove('lightbox-box__load--show')
    @imageEl.classList.remove('lightbox-box__image--load')

  close: =>
    # Unfreeze scrolling
    document.body.style.position = "static"
    document.body.scrollTop = @scrollTop

    # Remove blur
    @blur.classList.remove('lightbox-blur--show')
    @blur.removeEventListener('click', @close)
    # Remove lightbox
    document.body.removeChild(@lb)
    # Remove ref for this lightbox from gallery
    @lightboxGallery.deleteLightbox()
    # Rebind page arrow keys, remove esc listener
    bindArrows()
    Mousetrap.unbind('esc')
    window.disable_keyboard_nav = false


$(document).ready ->
  groups = document.querySelectorAll('.lightbox-group')

  # Initialise array, will remove old lightboxes on turbolink navigation
  lbs = []
  for group in groups
    lbs.push new LightboxGallery(group)

  window.lbs = lbs

