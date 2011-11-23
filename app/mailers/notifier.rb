# encoding: utf-8
class Notifier < ActionMailer::Base
  default from: "Инсомнис <insomnis.story@gmail.com>"

  def answer(comment)
    return unless comment.author_email
    @root    = root_url.sub(/\/$/, '')
    @comment = comment
    mail(to: comment.author_email, subject: answer_subject(@comment))
  end

protected

  def answer_subject(comment)
    if @comment.published?
      "Ответ на Ваш комментарий № #{comment.number} к «#{comment.post.title}»"
    else
      "Личный ответ на Ваш комментарий к «#{comment.post.title}»"
    end
  end
end
