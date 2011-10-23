#= require core/plague

plague.on '.title-page', ($, $$) ->
  title = $$('.title')

  # Центрирование обложки по вертикале

  bookHeight = title.outerHeight()
  book = $$('.book')
  centerBook = ->
    freeSpace = $(window).height() - bookHeight
    book.css(paddingTop: freeSpace / 2) if freeSpace > 20

  centerBook()
  $(window).resize(centerBook)

  # Открытие книги

  back = $$('.back-side')
  $$('@start-reading').click ->
    title.animate(opacity: 0, 200)
    back.fadeIn(200)
    after '200ms', => location.href = @href
    false
