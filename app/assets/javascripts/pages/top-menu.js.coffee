plague.on '.top-menu', ($, $$, topMenu) ->

  slider  =  $('@top-menu-slider')
  rotator = $$('@top-menu-rotator')

  # Появление меню

  topMenu.on 'show-menu', ->
    if plague.support.transform3d()
      topMenu.removeClass('hidden')
    else
      slider.show().animate(top: 0, 600)

  # Сокрытие меню

  topMenu.on 'hide-menu', ->
    if plague.support.transform3d()
      topMenu.addClass('hidden')
    else
      slider.animate(top: -40, 600, -> slider.hide())

  # Выпадающие меню

  openLinks = $$('@top-menu-open').click ->
    link   = $(@)
    hash   = link.attr('href')
    slide  = link.closest('.slide-button')
    opened = slide.hasClass('open')
    if opened
      slide.removeClass('open')
      $('body').off('click.hide-top-slide')
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
      $('body').on 'click.hide-top-slide', (e) ->
        unless $(e.target).closest('.slide-button').length
          slide.find('.button').click()
    false

  $(window).on 'hashchange', ->
    if location.hash == ''
      $('body').trigger('click.hide-top-slide')
    else
      link = openLinks.filter("[href=#{location.hash}]")
      link.click() unless link.data('opening')
  $(window).trigger('hashchange')

  $$('@subscribe-on-last').click ->
    hash = $(@).attr('href')
    openLinks.filter("[href=#{hash}]").click()
    false
