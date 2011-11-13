plague.flash =

  notice: (text) ->
    @autoHide @_show(@_div('notice', text))

  error: (text) ->
    @autoHide @_show(@_div('error', text))

  autoHide: (flash) ->
    flash.click => @_hide(flash)
    after '2.5sec', =>
      if flash.is(':hover')
        flash.mouseout => @_hide(flash)
      else
        @_hide(flash)

  _div: (type, html) ->
    $("<div class=\"flash #{type}\" />").html(html).appendTo('.flash-messages')

  _show: (flash) ->
    top = 36 + 30 + 7
    flash.css(top: top, lineHeight: '5px',  paddingLeft: 30, paddingRight: 30).
      animate(top: 30,  lineHeight: '36px', paddingLeft: 20, paddingRight: 20,
        1200, 'easeOutElastic')

  _hide: (flash) ->
    flash.animate top: 58, 400, 'easeInQuart', -> flash.remove()
