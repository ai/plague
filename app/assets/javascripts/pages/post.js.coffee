#= require jquery.cookie
#= require core/loader

currentPost = prevPost = null

recalculateScroll = ->

plague.on '.post-page', ($, $$, postPage) ->
  currentPost = prevPost = postPage
  $(window).bind 'load', ->
    immediate -> $(window).scrollTop(0)
  plague.loader.start()

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

  unless $.cookie('hightlighted-year')
    $$('@hightlight-year').show().animate(opacity: 0, 2500, 'easeInQuad')
    $.cookie('hightlighted-year', 1, expires: 365)

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
    prevNext.find('a.prev.post').attr(href: prev.data('url')) if prev.length

    next = postPage.next('.post-page')
    prevNext.toggleClass('last', !next.length)
    prevNext.find('a.next.post').attr(href: next.data('url')) if next.length

    prevPost = postPage
    currentPost = postPage
    recalculateScroll()
