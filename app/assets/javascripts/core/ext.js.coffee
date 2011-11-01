#= require jquery.chrono

window.after = jQuery.after
window.every = jQuery.every
window.immediate = (callback) -> setTimeout(callback, 0)

plague.ext =

  hash: (hash) ->
    scroll = $(window).scrollTop()
    document.location.hash = hash
    $(window).scrollTop(scroll)

  prefix: ->
    return 'moz'    if $.browser.mozilla
    return 'webkit' if $.browser.webkit
    return 'o'      if $.browser.opera
    return 'ms'     if $.browser.msie

  once: (name, callback) ->
    return if $.cookie(name) and location.hash != '#newvisit'
    $.cookie(name, 1, expires: 365, path: '/')
    callback()
