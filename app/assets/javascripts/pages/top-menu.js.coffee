plague.on '.top-menu', ($, $$) ->
  $$('.slide-button .button').click ->
    slide = $(@).closest('.slide-button')
    if slide.hasClass('open')
      after '200ms', -> slide.find('.content').hide()
      slide.removeClass('open')
    else
      slide.find('.content').show()
      immediate -> slide.addClass('open')
    false
