#= require core/loader
#= require jquery.noisy

plague.on '.title-page', -> plague.loader.start()

plague.live '.title-page', ($, $$, titlePage) ->
  title   = $$('.title')
  back    = $$('.back-side')
  topMenu =  $('.top-menu')

  # Шероховатость обложки

  title.noisy()

  # Центрирование обложки по вертикале

  bookHeight = title.outerHeight()
  book = $$('.book')
  centerBook = ->
    freeSpace = $(window).height() - bookHeight
    book.css(paddingTop: freeSpace / 2) if freeSpace > 20

  centerBook()
  $(window).resize(centerBook)

  # Открытие книги

  openBook = (callback) ->
    if plague.support.transform3d()
      titlePage.addClass('open-book')
    else
      title.animate(opacity: 0, 400)
      back.fadeIn(400)
    after '700ms', callback

  $$('@open-book').click ->
    unless plague.loader.loaded
      openBook => location.href = @href
      false

  titlePage.bind 'hide-page', ->
    plague.animation.start()
    $('.post-page').show()
    openBook ->
      topMenu.trigger('show-menu')
      titlePage.fadeOut 600, -> plague.animation.end()

  # Закрытие книги

  titlePage.bind 'show-page', ->
    plague.animation.start()
    plague.title()

    if $(window).scrollTop() < 50
      $(window).scrollTop(0)
      closeBook()
    else
      $('html, body').stop().animate(scrollTop: 0, 400, closeBook)

  closeBook = ->
    if plague.support.transform3d()
      titlePage.addClass('open-book')
    else
      title.css(opacity: 0)
      back.show()

    end = ->
      titlePage.css(position: 'absolute')
      plague.animation.end()

    topMenu.trigger('hide-menu')
    titlePage.fadeIn 600, ->
      if plague.support.transform3d()
        titlePage.removeClass('open-book')
        after '500ms', end
      else
        after '300ms', ->
          title.animate(opacity: 1, 400)
          back.fadeOut 400, end
      $('.post-page').hide()
