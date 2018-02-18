class LightboxGallery
  constructor: (galleryEm) ->
    @galleryEm = galleryEm
    @galleryLinks = galleryEm.querySelectorAll('.lightbox-link')

    for link in @galleryLinks
      link.addEventListener("click", @imageClick)

  imageClick: (ev) =>
    ev.preventDefault()
    ev.srcElement.blur()
    # Get image index in gallery
    i = @getLinkIndex ev.srcElement.parentElement

    @lightbox = new Lightbox(@, i)
    window.currentLightbox = @lightbox

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
    @scrollTop = $(document).scrollTop()
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
      <div class="lightbox-box__content">

      </div>
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

    # Image or video goes in here
    @contentEl = @lb.querySelector('.lightbox-box__content')
    @imageEl = null
    @videoEl = null

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

  setupImage: ->
    # Create image element to use
    @contentEl.innerHTML = "<img class=\"lightbox-box__image\" src=\"\" alt=\"\" />"
    @videoEl = null
    @imageEl = @contentEl.querySelector('.lightbox-box__image')
    # Add load complete event handler
    @imageEl.addEventListener('load', @imageLoaded)

  imageLoaded: (ev) =>
    # Image load has complete, hide spinner and fade in image
    @loadSpinnerEl.classList.remove('lightbox-box__load--show')
    @imageEl.classList.remove('lightbox-box__image--load')

  setupVideo: (src) ->
    # Create video element to use
    @contentEl.innerHTML = """<video class="lightbox-box__video lightbox-box__video--load" controls autoplay>
      <source src="#{src}" type="video/mp4" />
    </video>"""
    @imageEl = null
    @videoEl = @contentEl.querySelector('.lightbox-box__video')
    @videoEl.addEventListener('playing', @videoLoaded)

  videoLoaded: (ev) =>
    # Video load has complete, hide spinner and fade in image
    @loadSpinnerEl.classList.remove('lightbox-box__load--show')
    @videoEl.classList.remove('lightbox-box__video--load')
    ev.target.removeEventListener(ev.type, arguments.callee)

  changeImage: (i) ->
    @loadSpinnerEl.classList.add('lightbox-box__load--show')
    switch @lightboxGallery.galleryLinks[i].dataset.type
      when "image"
        if not @imageEl then @setupImage()
        @imageEl.classList.add('lightbox-box__image--load')
        @imageEl.src = @lightboxGallery.galleryLinks[i].href
      when "video"
        @setupVideo(@lightboxGallery.galleryLinks[i].href)
      else console.error('Invalid lightbox gallery type')
    @i = i

  close: =>
    # Unfreeze scrolling
    document.body.style.position = "static"
    $(document).scrollTop(@scrollTop)

    # Remove blur
    @blur.classList.remove('lightbox-blur--show')
    @blur.removeEventListener('click', @close)
    # Remove lightbox
    document.body.removeChild(@lb)
    # Remove ref for this lightbox from gallery
    @lightboxGallery.deleteLightbox()
    # Rebind page arrow keys, remove esc listener
    bindKeys()
    Mousetrap.unbind('esc')
    window.disable_keyboard_nav = false


document.addEventListener 'turbolinks:load', ->
  groups = document.querySelectorAll('.lightbox-group')

  # Initialise array, will remove old lightboxes on turbolink navigation
  lbs = []
  for group in groups
    lbs.push new LightboxGallery(group)

  window.lbs = lbs

