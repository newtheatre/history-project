# LazyImage: Lazy image loading

class LazyImage
  LAZY_CLASS = 'lazy-image'
  # Viewport plus this margin to trigger load
  LAZY_MARGIN = 660
  constructor: (opts) ->
    @imgEl = opts.imgEl
    @imgSrc = @imgEl.dataset.src
    @imgSrcSet = @imgEl.dataset.srcset

    window.requestAnimationFrame(@update)
    lastScroll = 0

  load: =>
    # Replace src with actual image src
    @imgEl.src = @imgSrc
    @imgEl.srcset = @imgSrcSet

  update: =>
    if (window.scrollY != @lastScroll) and (
      @imgEl.getBoundingClientRect().top < (window.innerHeight + LAZY_MARGIN) )
      @load()
    else
      window.requestAnimationFrame(@update)
      @lastScroll = window.scrollY

class LazyController

$(document).ready ->
  lazyImageEls = document.querySelectorAll('[data-src]')
  for lazyImageEl in lazyImageEls
    new LazyImage
      imgEl: lazyImageEl

# Unsure about destructor, we do not store references to old lazyimages and once
# the elemnts they pertain to are removed from the DOM they should* be garbage
# collected.