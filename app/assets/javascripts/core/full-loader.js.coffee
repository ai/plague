#= require jquery.chrono
#= require core/plague

loader = null

jQuery ($) ->
  loader = $('.full-loader')

plague.fullLoader =
  hide: ->
    loader.addClass('hide')
    after '900ms', -> loader.hide()
