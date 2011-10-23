plague.on '.top-menu', ($, $$) ->
  $$('.slide-button .button').click ->
    slide = $(@).closest('.slide-button')
    opened = slide.hasClass('open')
    if opened
      slide.removeClass('open')
      $('body').unbind('click.hide-top-slide')
      after '200ms', -> slide.find('.content').hide()
    else
      $('body').trigger('click.hide-top-slide')
      slide.find('.content').show()
      immediate -> slide.addClass('open')
      $('body').bind 'click.hide-top-slide', (e) ->
        unless $(e.target).closest('.top-menu').length
          slide.find('.button').click()
    false
