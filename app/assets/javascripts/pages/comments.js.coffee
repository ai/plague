#= require jquery.elastic

plague.live '.post-comments', ($, $$) ->
  $$('@add-comment').click ->
    $(@).closest('.post-page').find('.new-comment').slideToggle ->
      $(@).find('textarea').focus()

plague.live '.new-comment', ($, $$) ->
  postcard  = $$('.postcard')

  text      = $$('textarea')
  textLabel = $$('.text label')
  inputs    = $$('.row input')

  text.add(inputs).focus( -> postcard.addClass('focus')).
                   blur( -> postcard.removeClass('focus'))

  text.elastic()
  text.keyup -> textLabel.toggle(text.val() == '')

  textLabel.click -> text.focus()
