#= require core/plague

plague.on '.title-page', ($, $$) ->

  # Центрирование обложки по вертикале

  bookHeight = $$('.title').outerHeight()
  book = $$('.book')
  centerBook = ->
    freeSpace = $(window).height() - bookHeight
    book.css(paddingTop: freeSpace / 2) if freeSpace > 20

  centerBook()
  $(window).resize(centerBook)
