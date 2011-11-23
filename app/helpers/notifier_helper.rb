# encoding: utf-8
module NotifierHelper
  def format_comment_mail(text)
    text.split("\n").map { |i| "> " + i }.join("\n").html_safe
  end

  def hello_with_name(name)
    'Здравствуйте' + (name.present? ? ", #{name}" : '') + '.'
  end

  def blockquote(text)
    html = h(text).gsub(/\n/, '<br />').html_safe
    content_tag :blockquote, html,
      style: 'display: block; margin: 1ex 0 0 0.8ex; ' +
             'border-left: 1px solid gray; padding-left: 1ex;'
  end
end
