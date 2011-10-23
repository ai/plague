#= require core/plague

loader = null

jQuery ($) ->
  loader = $('.full-loader')
  plague.fullLoader.hideOnLoad() if loader

plague.fullLoader =
  hide: ->
    loader.addClass('hide')
    after '900ms', -> loader.hide()

  quickHide: ->
    loader.hide().addClass('hide')

  hideOnLoad: ->
    startLoading = new Date()
    $(window).bind 'load', ->
      loadingTime = new Date() - startLoading
      if loadingTime < 500
        plague.fullLoader.quickHide()
      else
        plague.fullLoader.hide()
