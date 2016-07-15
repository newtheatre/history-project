class AnimatedScroll
  constructor: (scrollEnd, scrollDuration) ->
    @scrollStart = window.scrollY
    @scrollStep = Math.PI / scrollDuration
    @cosParameter = (@scrollStart - scrollEnd) / 2

    @scrollEnd = scrollEnd
    @scrollDuration = scrollDuration

    @scrollCount = 0

    @firstTs = null

  go: ->
    requestAnimationFrame(@step)

  step: (ts) =>
    if not @firstTs
      @firstTs = ts

    animationTime = ts - @firstTs

    if animationTime <= @scrollDuration
      requestAnimationFrame(@step)
      scrollMargin = @cosParameter - @cosParameter * Math.cos( animationTime * @scrollStep )
      window.scrollTo(0, @scrollStart - scrollMargin)
    else
      window.scrollTo(0, @scrollEnd)

scrollToAnimated = (pos, duration) ->
  as = new AnimatedScroll(pos, duration)
  as.go()
