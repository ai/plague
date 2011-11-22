startFromPost = false
currentPost   = prevPost = null

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

changeTitleLinks = (post) ->
  controls = $('.title-page .controls')
  controls.find('> div').hide()
  unless post.prev('.post-page').length
    controls.find('.start-reading').show()
  else unless post.next('.post-page').length
    controls.find('.wait-new-post').show()
  else
    controls.find('.continue-reading').show().
      find('a.open-badge').attr(href: post.data('url'))

changeTopTitle = (title, isNext) ->
  topTitle = $('@current-title')
  slider   = $('@title-slider')
  height   = slider.height()
  if isNext
    $('@prev-title-bottom').text(topTitle.text())
    slider.stop().css(marginTop: -2 * height).animate(marginTop: -height, 400)
  else
    $('@prev-title-top').text(topTitle.text())
    slider.stop().css(marginTop: 0).animate(marginTop: -height, 400)
  topTitle.text(title)

changePrev = (prev) ->
  $('@prev-next-page').toggleClass('first', !prev.length)
  $('@prev-page').attr(href: prev.data('url')) if prev.length

changeNext = (next) ->
  $('@prev-next-page').toggleClass('last', !next.length)
  $('@next-page').attr(href: next.data('url')) if next.length

plague.on '.post-page', ($, $$, postPage) ->
  startFromPost = true
  currentPost   = prevPost = postPage
  $(window).on 'load', ->
    hightlightYear('300ms')

  rememberReading(postPage)
  plague.loader.start() unless postPage.data('draft')

# Переключение постов по скроллу

plague.loader.ready ->
  win = $(window)

  currentPost = prevPost = $('.post-page:first') unless currentPost
  before = after = null
  recalculateScroll = ->
    before = currentPost.offset().top - $('.top-menu').height()
    after  = before + currentPost.outerHeight(true)
  win.resize(recalculateScroll)
  recalculateScroll()

  win.on 'scroll', ->
    return if plague.animation.animating
    return if location.pathname == '/'
    x = win.scrollTop()
    if x < before
      prev = currentPost.prev('.post-page:first')
      if prev.length
        plague.loader.openUrl(prev.data('url'), 'scroll')
    else if x > after
      next = currentPost.next('.post-page:first')
      if next.length
        plague.loader.openUrl(next.data('url'), 'scroll')

plague.live '.post-page', ($, $$, postPage) ->
  hightlightYear('2s') unless startFromPost

  # Открытие поста

  postPage.on 'show-page', (e, source) ->
    currentPost = postPage

    plague.title(postPage.data('title'), currentPost.data('story'))
    titlePage = $('.title-page')
    titlePage.trigger('hide-page') if titlePage.is(':visible')

    topMenu  = $('.top-menu')
    prevNext = topMenu.find('.prev-next')

    plague.animation.wait ->
      changeTitleLinks(currentPost)
      if source != 'scroll'
        plague.animation.start()
        top = postPage.offset().top - topMenu.height() + 30
        plague.ext.scroll top, ->
          plague.animation.end()

    changePrev(prev = postPage.prev('.post-page'))
    changeNext(next = postPage.next('.post-page'))
    changeTopTitle(postPage.data('title'), next.is(prevPost))

    prevPost = postPage
    recalculateScroll()

    rememberReading(currentPost)
