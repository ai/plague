#= require core/loader
#= require jquery.noisy

plague.on '.title-page', -> plague.loader.start()

plague.live '.title-page', ($, $$, titlePage) ->
  title   = $$('.title')
  back    = $$('.back-side')
  topMenu =  $('.top-menu-fixed')

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
    title.animate(opacity: 0, 400)
    back.fadeIn(400, callback)

  $$('@start-reading').click ->
    unless plague.loader.loaded
      openBook => location.href = @href
      false

  titlePage.bind 'hide-page', ->
    plague.animation.start()
    $('.post-page').show()
    openBook ->
      after '300ms', ->
        topMenu.animate(top: 0, 600)
        titlePage.fadeOut(600, -> plague.animation.end())

  # Закрытие книги

  titlePage.bind 'show-page', ->
    $(window).scrollTop(0)
    plague.animation.start()
    plague.title()
    topMenu.animate(top: -40, 600)
    titlePage.fadeIn 600, ->
      after '300ms', ->
        title.animate(opacity: 1, 400)
        back.fadeOut(400, -> plague.animation.end())
        $('.post-page').hide()
