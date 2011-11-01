#= require jquery.cookie
#= require core/loader

startFromPost = false

currentPost = prevPost = null

recalculateScroll = ->

hightlightYear = (delay) ->
  return if $.cookie('hightlighted-year')
  $.cookie('hightlighted-year', 1, expires: 365)

  console.log(delay)
  after delay, ->
    console.log($('@hightlight-year'))
    $('@hightlight-year').show().css(opacity: 0).
      animate(opacity: 1, 400).
      animate(opacity: 0, 2500, 'easeInQuad')

plague.on '.post-page', ($, $$, postPage) ->
  startFromPost = true
  currentPost = prevPost = postPage
  plague.loader.start() unless postPage.data('draft')
  $(window).bind 'load', ->
    hightlightYear('300ms')
    immediate ->
      $(window).scrollTop(0)

plague.loader.ready ->
  win = $(window)

  currentPost = prevPost = $('.post-page:first') unless currentPost
  before = after = null
  recalculateScroll = ->
    paper  = currentPost.find('.paper')
    before = paper.offset().top - (2 * $('.top-menu').height())
    after  = before + paper.outerHeight(true)
  win.resize(recalculateScroll)
  recalculateScroll()

  win.bind 'scroll', ->
    return if plague.animation.animating
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

  postPage.bind 'show-page', (e, source) ->
    plague.title(postPage.data('title'), postPage.data('story'))
    titlePage = $('.title-page')
    titlePage.trigger('hide-page') if titlePage.is(':visible')

    topMenu  = $('.top-menu')
    prevNext = topMenu.find('.prev-next')

    if source != 'scroll'
      plague.animation.start()
      top = postPage.offset().top - topMenu.height()
      $('html, body').stop().animate scrollTop: top, 400, ->
        plague.animation.end()

    topTitle = topMenu.find('.current-title')
    slider   = topMenu.find('.top-title')
    height   = topMenu.height()
    if postPage.nextAll('.post-page').is(prevPost)
      topMenu.find('.bottom-title').text(topTitle.text())
      slider.stop().css(marginTop: -2 * height).animate(marginTop: -height, 400)
    else
      topMenu.find('.top-title').text(topTitle.text())
      slider.stop().css(marginTop: 0).animate(marginTop: -height, 400)
    topTitle.text(postPage.data('title'))

    prev = postPage.prev('.post-page')
    prevNext.toggleClass('first', !prev.length)
    prevNext.find('a.prev.page').attr(href: prev.data('url')) if prev.length

    next = postPage.next('.post-page')
    prevNext.toggleClass('last', !next.length)
    prevNext.find('a.next.page').attr(href: next.data('url')) if next.length

    prevPost = postPage
    currentPost = postPage
    recalculateScroll()
