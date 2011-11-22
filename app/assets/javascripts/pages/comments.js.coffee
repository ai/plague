#= require jquery.elastic

plague.live '.post-comments', ($, $$, comments) ->
  newComment = comments.parent().find('.new-comment')

  # Отображение остальных комментариев

  $$('@show-more-comments').click ->
    more = $$('@more-comments')
    if more.find('.comment').length == 0
      $$('@add-comment').click()
    else
      more.slideDown()
      $$('.comments-controls').slideUp()
      newComment.slideDown()
    false

  # Появление формы добавления комментария

  $$('@add-comment').click ->
    if newComment.is(':visible')
      newComment.slideUp()
    else
      height = newComment.outerHeight()
      scroll = $(window).scrollTop()
      newComment.slideDown ->
        $(@).find('textarea').focus()
      if newComment.offset().top + height > scroll + $(window).height()
        $('html, body').stop().animate scrollTop: height + scroll, 400
    false

  # Отображение ID комментария для модерации

  if $.cookie('author')
    $$('.comment .info').dblclick ->
      console.log("c = Comment.find('#{$(@).closest('.comment').data('id')}')")

plague.live '.new-comment', ($, $$, newComment) ->
  postcard  = $$('.postcard')
  form      = $$('form')
  text      = $$('textarea')
  textLabel = $$('.text label')
  inputs    = $$('.row input')
  mailbox   = $$('.mailbox')

  # Эффект при выборе поля ввода

  text.add(inputs).focus( -> postcard.addClass('focus')).
                   blur( -> postcard.removeClass('focus'))

  # Автоувеличение формы для текста комментария

  text.elastic()

  # Название поля повверх поля

  text.on 'keyup change', -> textLabel.toggle(text.val() == '')
  textLabel.click -> text.focus()

  # Привлекаем внимание к описанию, зачем нам эл. почта

  emailNotice = $$('.email-notice')
  inputs.filter('[type=email]').
    focus( -> emailNotice.addClass('highlighted')).
    blur( -> emailNotice.removeClass('highlighted'))

  # Хак, чтобы при AJAX-отправке сохранялось имя submit-кнопки

  $$(':submit[name]').click ->
    $(@).closest('form').trigger('submit', $(@).attr('name'))
    false

  # Отправка комментария

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
      text.val('').change()
      sent.animate top: -sent.outerHeight() - 3, 500, 'easeInQuad', ->
        after '1s', -> mailbox.fadeOut(400)
    ajax.error (e) ->
      if 500 <= e.status <= 599
        plague.flash.error('Ошибка сервера')
      else
        plague.flash.error(e.responseText)
      mailbox.fadeOut(200)

    false
