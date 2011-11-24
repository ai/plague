# encoding: utf-8
module NotifierHelper
  def format_comment_mail(text)
    text.split("\n").map { |i| "> " + i }.join("\n").html_safe
  end

  def hello_with_name(comment)
    time = comment.author_time
    name = comment.author_name
    hello_by_time(time) + (name.present? ? ", #{name}" : '') + '.'
  end

  def blockquote(text)
    html = h(text).gsub(/\n/, '<br />').html_safe
    content_tag :blockquote, html,
      style: 'display: block; margin: 1ex 0 0 0.8ex; ' +
             'border-left: 1px solid gray; padding-left: 1ex;'
  end

  def hello_by_time(time)
    case time.hour
    when 0..3
      'Доброй ночи'
    when 4..11
      'Доброе утро'
    when 12..16
      'Добрый день'
    when 17..23
      'Добрый вечер'
    end
  end
end
