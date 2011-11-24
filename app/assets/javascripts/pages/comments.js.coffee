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

  $(window).on 'hashchange', ->
    if location.hash.match(/^#comment/)
      commentByHash(location.hash).trigger('scroll-to-comment', 'animated')

plague.live '.post-comments', ($, $$, comments) ->
  newComment   = comments.parent().find('.new-comment')
  moreComemnts = $$('@more-comments')
  controls     = $$('.comments-controls')

  watchCommentHash()

  $$('.comment').on 'scroll-to-comment', (e, animated) ->
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
