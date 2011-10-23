#= require jquery.role
#= require core/ext

window.plague =
  on: (selector, callback) ->
    jQuery ->
      content = $(selector)
      if content.length
        $$ = (selector) ->
          jQuery(selector, content)
        callback.apply content, [ jQuery, $$, content ]
