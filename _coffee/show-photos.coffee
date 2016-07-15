class ProdShotsGallery
  maxImages:
    limited: 4
    full: 12

  constructor: (opts) ->
    @elemContainer = opts.elemContainer
    
    @toggleButton = @elemContainer.querySelector('[data-gallery-toggle]')
    @showLabel = @elemContainer.querySelector('[data-show-label]')
    @hideLabel = @elemContainer.querySelector('[data-hide-label]')
    @fadeOverlay = @elemContainer.querySelector('.fade-out-overlay')

    @gallery = @elemContainer.querySelector('.show-photos')
    @galleryInner = @elemContainer.querySelector('.show-photos__inner')

    @galleryOpen

    @controls = @elemContainer.querySelector('.show-photos-controls')

    # Lazy image loading
    @lazyImages = @elemContainer.querySelectorAll('.lazy-image')
    @lazyComplete = false
    @prePreLoad()

    # Limited gallery (doesn't open, just forwards to smugmug)
    @limitedGallery = @elemContainer.querySelector('.gallery-control').style.display == "none"
    
    # Event listeners
    if not @limitedGallery
      @toggleButton.addEventListener('click', @toggleClick)
      @fadeOverlay.addEventListener('click', @toggleClick)
      window.requestAnimationFrame(@computeControlStickyness)

  prePreLoad: ->
    if @limitedGallery
      pre = @maxImages.limited
    else
      pre = @maxImages.full

    for iKey in [0..pre]
      @lazyLoad(@lazyImages[iKey])

  lazyLoad: (elem) ->
    if elem.src != elem.dataset.lazySrc
      elem.src = elem.dataset.lazySrc

  lazyLoads: (elems) ->
    for elem in elems
      @lazyLoad(elem)
    @lazyComplete = true

  toggleClick: (ev) =>
    ev.preventDefault()
    @toggleButton.blur()

    if @galleryOpen
      @closeGallery(ev)
    else
      @openGallery(ev)

  openGallery: (ev) =>
    # Open gallery
    @galleryInner.classList.add('show-photos__inner--show')
    @controls.classList.add('show-photos-controls--sticky')
    @galleryInner.style.maxHeight = "#{@galleryInner.scrollHeight}px"
    @showLabel.style.display = "none"
    @fadeOverlay.style.display = "none"
    @hideLabel.style.display = "block"
    # Lazy load images if needed
    if not @lazyComplete
      @lazyLoads(@lazyImages)

    @galleryOpen = true

  closeGallery: (ev) =>
    # Hide gallery
    @galleryInner.classList.remove('show-photos__inner--show')
    @controls.classList.remove('show-photos-controls--sticky')
    @galleryInner.style.maxHeight = ""
    @showLabel.style.display = "block"
    @fadeOverlay.style.display = "block"
    @hideLabel.style.display = "none"

    @galleryOpen = false

    scrollToAnimated(@gallery.offsetTop-200, 160)

  computeControlStickyness: =>
    # Sticks the controls to bottom when scrolled beneith, hides
    # when beyond bounds of elemContainer
    if @galleryOpen
      viewportBottom = window.scrollY + window.innerHeight
      galleryTop = @gallery.offsetTop
      galleryBottom = @gallery.offsetHeight + @gallery.offsetTop
      controlsHeight = @controls.offsetHeight

      if viewportBottom > (galleryBottom + controlsHeight) or viewportBottom < (galleryTop + controlsHeight)
        @controls.classList.remove('show-photos-controls--sticky')
        @elemContainer.style.paddingBottom = ""
      else
        @controls.classList.add('show-photos-controls--sticky')
        @elemContainer.style.paddingBottom = "#{controlsHeight}px"

    window.requestAnimationFrame(@computeControlStickyness)


$(document).ready ->
  prodShotsGalleryElem = document.querySelector('#show-prod-shots')
  if prodShotsGalleryElem
    window.prodShotsGallery = new ProdShotsGallery
      elemContainer: prodShotsGalleryElem
