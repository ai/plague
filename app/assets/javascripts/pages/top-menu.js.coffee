plague.on '.top-menu', ($, $$, topMenu) ->

  fixed   = $$('.top-menu-fixed')
  rotator = $$('.top-menu-rotator')

  # Появление меню

  topMenu.bind 'show-menu', ->
    if plague.support.transform3d()
      topMenu.removeClass('hidden')
    else
      fixed.show().animate(top: 0, 600)

  # Сокрытие меню

  topMenu.bind 'hide-menu', ->
    if plague.support.transform3d()
      topMenu.addClass('hidden')
    else
      fixed.animate(top: -40, 600, -> fixed.hide())

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
