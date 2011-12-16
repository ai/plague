startFromPost = false

topMenu = null
$(document).ready -> topMenu = $('.top-menu')

recalculateScroll = ->

hightlightYear = (delay) ->
  plague.ext.once 'hightlighted-year', ->
    after delay, ->
      $('@hightlight-year').show().css(opacity: 0).
        animate(opacity: 1, 400).
        animate(opacity: 0, 2500, 'easeInQuad')

rememberReading = (post) ->
  return if post.data('draft')
  last = post.hasClass('last-post')
  $.cookie('reading', post.data('url'), expires: 365, path: '/')
  $.cookie('reading-last', (if last then 1 else null), expires: 365, path: '/')

postTop = (postPage) ->
  if postPage.hasClass('first-post')
    0
  else
    postPage.offset().top - topMenu.height() + 60

plague.on '.post-page', ($, $$, postPage) ->
  startFromPost = true
  $(window).on 'load', ->
    hightlightYear('300ms')
    immediate -> $(window).scrollTop(0)
  plague.full.ready ->
    $(window).scrollTop(postTop(postPage))

  rememberReading(postPage)
  plague.full.start() unless postPage.data('draft')

# Переключение постов по скроллу

plague.full.ready ->
  win = $(window)
  before = after = null

  recalculateScroll = ->
    before  = plague.full.current.offset().top - $('.top-menu').height()
    after   = before + plague.full.current.outerHeight(true)
  win.resize(recalculateScroll)
  recalculateScroll()

  afterLastPost = false
  win.on 'scroll', ->
    return if plague.animation.animating
    return if location.pathname == '/'
    x = win.scrollTop()
    if x < before
      prev = plague.full.current.prev('.post-page:first')
      if prev.length
        plague.full.openUrl(prev.data('url'), 'scroll')
    else if x > after
      next = plague.full.current.next('.post-page:first')
      if next.length
        plague.full.openUrl(next.data('url'), 'scroll')
      else unless afterLastPost
        afterLastPost = true
        $('.to-be-continue').trigger('show-page')
    else if afterLastPost
      afterLastPost = false
      $('.to-be-continue').trigger('hide-page')

plague.on '.to-be-continue', ($, $$, toBeContinue) ->
  toBeContinue.on 'show-page', ->
    last = $('.post-page:last')
    plague.topMenu.prev(last).on 'click.return-to-last', ->
      toBeContinue.trigger('hide-page')
      plague.ext.scroll(postTop(last))
      false
  toBeContinue.on 'hide-page', ->
    plague.topMenu.prev($('.post-page:last').prev('.post-page:first')).
      off('click.return-to-last')

plague.live '.post-page', ($, $$, postPage) ->
  hightlightYear('2s') unless startFromPost

  # Открытие записи

  postPage.on 'show-page', (e, source) ->
    prevNext = topMenu.find('.prev-next')

    plague.documentTitle(postPage.data('title'), postPage.data('story'))
    titlePage = $('.title-page')
    if titlePage.is(':visible')
      titlePage.trigger('hide-page')
      scrolled = true
      if plague.data.closedPost?.url == postPage.data('url')
        $(window).scrollTop(plague.data.closedPost.scroll)
      else
        $(window).scrollTop(postTop(postPage))

    plague.animation.wait ->
      plague.title.changeLinks(postPage)
      if source != 'scroll' and not scrolled
        plague.animation.start()
        plague.ext.scroll postTop(postPage), ->
          plague.animation.end()

    plague.topMenu.prev(prev = postPage.prev('.post-page'))
    plague.topMenu.next(next = postPage.next('.post-page'))
    plague.topMenu.title(postPage.data('title'), next.is(plague.full.prev))

    recalculateScroll()

    rememberReading(postPage)
