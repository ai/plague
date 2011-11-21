loader = null

jQuery ($) ->
  loader = $('.full-loader')
  if loader
    plague.fullLoader.startAnimation()
    plague.fullLoader.hideOnLoad()

plague.fullLoader =
  _rotation: null

  hide: ->
    loader.addClass('hide')
    after '900ms', =>
      @stopAnimation()
      loader.hide()

  quickHide: ->
    @stopAnimation()
    loader.hide().addClass('hide')

  startAnimation: ->
    return if plague.support.css3animation()
    start     = new Date()

    ouroboros = loader.find('.ouroboros')
    if ouroboros[0].style.transform != undefined
      prop = 'transform'
    else
      prop = "#{plague.ext.cssPrefix()}transform"

    @_rotation = every '10ms', ->
      ms  = (new Date()) - start
      i   = (ms % 2500) / 2500.0
      deg = Math.round(360 * i)
      ouroboros.css(prop, "rotate(#{deg}deg)")

  stopAnimation: ->
    clearInterval(@_rotation) if @_rotation

  hideOnLoad: ->
    startLoading = new Date()
    $(window).on 'load', ->
      loadingTime = new Date() - startLoading
      if loadingTime < 500
        plague.fullLoader.quickHide()
      else
        plague.fullLoader.hide()
