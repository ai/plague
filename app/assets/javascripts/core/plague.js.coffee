#= require jquery.role
#= require jquery.easing
#= require core/ext

window.plague =
  on: (selector, callback) ->
    jQuery ->
      content = $(selector)
      if content.length
        $$ = (selector) ->
          jQuery(selector, content)
        callback.apply content, [ jQuery, $$, content ]

  hash: (hash) ->
    scroll = $(window).scrollTop()
    document.location.hash = hash
    $(window).scrollTop(scroll)
