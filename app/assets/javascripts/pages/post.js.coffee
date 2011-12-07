startFromPost = false
currentPost   = prevPost = null

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

postTop = (postPage) ->
  if postPage.hasClass('first-post')
    0
  else
    postPage.offset().top - topMenu.height() + 60

plague.on '.post-page', ($, $$, postPage) ->
  startFromPost = true
  currentPost   = prevPost = postPage
  plague.data.currentPost  = currentPost
  $(window).on 'load', ->
    hightlightYear('300ms')
    immediate -> $(window).scrollTop(0)
  plague.loader.ready ->
    $(window).scrollTop(postTop(postPage))

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

  afterLastPost = false
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
      else unless afterLastPost
        afterLastPost = true
        $('.to-be-continue').trigger('show-page')
    else if afterLastPost
      afterLastPost = false
      $('.to-be-continue').trigger('hide-page')

plague.on '.to-be-continue', ($, $$, toBeContinue) ->
  toBeContinue.on 'show-page', ->
    last = $('.post-page:last')
    changePrev(last).on 'click.return-to-last', ->
      toBeContinue.trigger('hide-page')
      plague.ext.scroll(postTop(last))
      false
  toBeContinue.on 'hide-page', ->
    changePrev($('.post-page:last').prev('.post-page:first')).
      off('click.return-to-last')

plague.live '.post-page', ($, $$, postPage) ->
  hightlightYear('2s') unless startFromPost

  # Открытие поста

  postPage.on 'show-page', (e, source) ->
    currentPost = postPage
    prevNext    = topMenu.find('.prev-next')
    plague.data.currentPost = currentPost

    plague.title(postPage.data('title'), postPage.data('story'))
    titlePage = $('.title-page')
    if titlePage.is(':visible')
      titlePage.trigger('hide-page')
      scrolled = true
      if plague.data.closedPost?.url == postPage.data('url')
        $(window).scrollTop(plague.data.closedPost.scroll)
      else
        $(window).scrollTop(postTop(postPage))

    plague.animation.wait ->
      changeTitleLinks(postPage)
      if source != 'scroll' and not scrolled
        plague.animation.start()
        plague.ext.scroll postTop(postPage), ->
          plague.animation.end()

    changePrev(prev = postPage.prev('.post-page'))
    changeNext(next = postPage.next('.post-page'))
    changeTopTitle(postPage.data('title'), next.is(prevPost))

    prevPost = postPage
    recalculateScroll()

    rememberReading(postPage)
