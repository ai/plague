#= require jquery.elastic

# Прокрутка к комментарию при нажатию на ссылку

commentByHash = (hash) ->
  number = hash.replace(/^#comment/, '')
  $("article.comment[data-number=#{number}]")

plague.on '.post-comments', ($, $$) ->
  $(window).on 'load', ->
    if location.hash.match(/^#comment/)
      immediate ->
        commentByHash(location.hash).trigger('scroll-to-comment')

commentCacheIsWatching = false
watchCommentHash = ->
  return if commentCacheIsWatching
  commentCacheIsWatching = true

  $(window).bind 'hashchange', ->
    if location.hash.match(/^#comment/)
      commentByHash(location.hash).trigger('scroll-to-comment', 'animated')

plague.live '.post-comments', ($, $$, comments) ->
  newComment   = comments.parent().find('.new-comment')
  moreComemnts = $$('@more-comments')
  controls     = $$('.comments-controls')

  watchCommentHash()

  $$('.comment').bind 'scroll-to-comment', (e, animated) ->
    comment = $(@)
    if comment.closest('@more-comments').length
      moreComemnts.show()
      controls.hide()
      newComment.show()

    top = comment.offset().top - 45
    top -= 5 if comment.hasClass('real-life')
    if animated
      plague.animation.wait ->
        plague.ext.scroll(top)
    else
      $(window).scrollTop(top)

  # Отображение остальных комментариев

  $$('@show-more-comments').click ->
    if moreComemnts.find('.comment').length == 0
      $$('@add-comment').click()
    else
      moreComemnts.slideDown()
      controls.slideUp()
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
        plague.ext.scroll(height + scroll)
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
