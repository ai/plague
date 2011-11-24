plague.on '.title-page', -> plague.loader.start()

plague.live '.title-page', ($, $$, titlePage) ->
  title   = $$('.title')
  back    = $$('.back-side')
  topMenu =  $('.top-menu')

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

  titlePage.on 'hide-page', ->
    plague.animation.start()
    titlePage.css(position: 'fixed')
    $('.post-page').show()
    openBook ->
      topMenu.trigger('show-menu')
      titlePage.fadeOut 600, -> plague.animation.end()

  # Закрытие книги

  titlePage.on 'show-page', ->
    plague.data.closedPost =
      url:    plague.data.currentPost.data('url')
      scroll: $(window).scrollTop()

    plague.animation.start()
    plague.title()
    titlePage.css(position: 'fixed')
    closeBook()

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
