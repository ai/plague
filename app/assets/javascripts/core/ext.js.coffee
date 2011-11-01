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
    if plague.support.localStore()
      remember = localStorage.getItem("once-#{name}")
    else
      remember = $.cookie(name)
    return if remember and location.hash != '#newvisit'

    if plague.support.localStore()
      localStorage.setItem("once-#{name}", 1)
    else
      $.cookie(name, 1, expires: 365, path: '/')
    callback()
