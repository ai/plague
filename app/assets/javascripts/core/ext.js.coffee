#= require jquery.chrono

window.after = jQuery.after
window.every = jQuery.every
window.immediate = (callback) -> setTimeout(callback, 0)

plague.ext =

  hash: (hash) ->
    scroll = $(window).scrollTop()
    document.location.hash = hash
    $(window).scrollTop(scroll)

  scroll: (top, callback) ->
    $('html, body').stop().animate(scrollTop: top, 400, callback)

  cssPrefix: ->
    return '-moz-'    if $.browser.mozilla
    return '-webkit-' if $.browser.webkit
    return '-o-'      if $.browser.opera
    return '-ms-'     if $.browser.msie

  domPrefix: ->
    return 'Moz'    if $.browser.mozilla
    return 'Webkit' if $.browser.webkit
    return 'O'      if $.browser.opera
    return 'ms'     if $.browser.msie

  once: (name, callback) ->
    name = "once-#{name}"
    return if plague.storage(name) and location.hash != '#newvisit'
    plague.storage(name, 1)
    callback()
