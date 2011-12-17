plague.on '.to-be-continue', ($, $$, toBeContinue) ->

  toBeContinue.on 'show-page', (e, source) ->
    if source != 'scroll'
      plague.animation.start()
      plague.ext.scroll $('.to-be-continue').offset().top, ->
        plague.animation.end()

    last = $('.post-page:last')
    plague.topMenu.title('', false)
    plague.topMenu.prev(last)

$(document).ready ->
  $('@go-to-be-continue').click ->
    plague.full.openPage($('.to-be-continue'))
    false
