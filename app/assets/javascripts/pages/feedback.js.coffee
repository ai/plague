#= require jquery.hoverIntent

$(document).ready ->
  $('.feedback-content').hoverIntent
    over: -> $(@).addClass('hover')
    out: -> $(@).removeClass('hover')
