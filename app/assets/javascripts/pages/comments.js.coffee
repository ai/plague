#= require jquery.elastic

plague.live '.post-comments', ($, $$, comments) ->
  $$('@add-comment').click ->
    newComment = $(@).closest('.post-page').find('.new-comment')
    if newComment.is(':visible')
      newComment.slideUp()
    else
      newComment.slideDown ->
        $(@).find('textarea').focus()
      top = newComment.offset().top - 67
      $('html, body').stop().animate scrollTop: top, 400

plague.live '.new-comment', ($, $$, newComment) ->
  postcard  = $$('.postcard')
  form      = $$('form')
  text      = $$('textarea')
  textLabel = $$('.text label')
  inputs    = $$('.row input')
  mailbox   = $$('.mailbox')

  text.add(inputs).each( -> $(@).data(default: $(@).val()) ).
    focus( -> postcard.addClass('focus')).
    blur( -> postcard.removeClass('focus'))

  text.elastic()
  text.on 'keyup change', -> textLabel.toggle(text.val() == '')

  textLabel.click -> text.focus()

  emailNotice = $$('.email-notice')
  inputs.filter('[type=email]').
    focus( -> emailNotice.addClass('highlighted')).
    blur( -> emailNotice.removeClass('highlighted'))

  $$(':submit[name]').click ->
    $(@).closest('form').trigger('submit', $(@).attr('name'))
    false

  form.submit (e, submiter) ->
    if $.trim(text.val()) == ''
      plague.flash.error('Введите текст комментария')
      text.focus()
      return false

    return false if form.hasClass('sending')
    form.addClass('sending')
    mailbox.fadeIn(200)

    data = form.serialize()
    data += "&#{submiter}=1" if submiter

    ajax = $.post(form.attr('action'), data)
    ajax.complete ->
      form.removeClass('sending')
    ajax.success ->
      sent = form.clone().addClass('sent').insertBefore(form)
      text.add(inputs).each -> $(@).val($(@).data('default')).change()
      sent.animate top: -sent.outerHeight() - 3, 500, 'easeInQuad', ->
        after '1s', -> mailbox.fadeOut(400)
    ajax.error (e) ->
      if e.status == 500
        plague.flash.error('Ошибка сервера')
      else
        plague.flash.error(e.responseText)
      mailbox.fadeOut(200)

    false
