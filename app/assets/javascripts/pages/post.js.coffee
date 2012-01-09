startFromPost = false

topMenu = null
$(document).ready -> topMenu = $('.top-menu')

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
  $(window).load ->
    hightlightYear('300ms')
  plague.full.ready ->
    unless location.hash.match(/^#comment/)
      $(window).scrollTop(postTop(postPage))
    plague.scroll.watch()

  rememberReading(postPage)
  plague.full.start() unless postPage.data('draft')

plague.live '.post-page', ($, $$, postPage) ->
  hightlightYear('2s') unless startFromPost

  $$('@post-link').attr(target: '_blank').track()

  # Открытие записи

  postPage.on 'show-page', (e, source) ->
    plague.scroll.watch()

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

    plague.topMenu.prev(postPage.prev('.post-page'))
    plague.topMenu.next(next = postPage.next('article.page'))
    plague.topMenu.title(postPage.data('title'), next.is(plague.full.prev))

    rememberReading(postPage)
