win = $(window)

topMenuHeight = 0
$(document).ready -> topMenuHeight = $('.top-menu').height()

plague.scroll =

  watching: false

  before: null

  after: null

  watch: ->
    return if @watching
    @recalculate()
    @watching = true

  unwatch: ->
    @watching = false

  recalculate: ->
    @before = plague.full.current.offset().top - topMenuHeight
    @after  = @before + plague.full.current.outerHeight(true)

  _open: (page) ->
    return unless page.length
    return if page.is('.title-page')

    if page.data('url')
      url = page.data('url') + location.hash
      plague.full.openUrl(url, 'scroll')
    else
      plague.full.openPage(page, 'scroll')
    @recalculate()

  _scroll: ->
    return unless @watching
    x = win.scrollTop()
    if x < @before
      @_open(plague.full.current.prev('article.page:first'))
    else if x > @after
      @_open(plague.full.current.next('article.page:first'))

plague.full.ready ->
  win.resize -> plague.scroll.recalculate()
  win.scroll -> plague.scroll._scroll()
