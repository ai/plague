plague.on '.top-menu', ($, $$) ->

  # Выпадающие меню

  $$('.slide-button .button').click ->
    link   = $(@)
    hash   = link.attr('href')
    slide  = link.closest('.slide-button')
    opened = slide.hasClass('open')
    if opened
      slide.removeClass('open')
      $('body').unbind('click.hide-top-slide')
      after '200ms', -> slide.find('.content').hide()
      plague.ext.hash('') if location.hash == hash
    else
      plague.ext.hash(hash)
      $('body').trigger('click.hide-top-slide')
      slide.find('.content').show()
      link.data(opening: true)
      immediate ->
        slide.addClass('open')
        link.data(opening: null)
      $('body').bind 'click.hide-top-slide', (e) ->
        unless $(e.target).closest('.top-menu').length
          slide.find('.button').click()
    false

  $(window).bind 'hashchange', ->
    if location.hash == ''
      $('body').trigger('click.hide-top-slide')
    else
      link = $$("a[href=#{location.hash}]")
      link.click() unless link.data('opening')
  $(window).trigger('hashchange')
