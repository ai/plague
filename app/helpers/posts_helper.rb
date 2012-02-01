# encoding: utf-8
module PostsHelper

  def open_badge(text, post, type)
    if type == :start
      cls  = ' start'
      role = 'start-reading'
    else
      cls  = ' continue'
      role = 'continue-reading'
    end
    attrs = { href: post.try(:url), class: cls, role: role }
    render partial: 'open_badge', locals: { text: text, attrs: attrs }
  end

  def output_symbols(text)
    text.gsub('<p>—', '<p class="mdash-first">—').html_safe
  end

  def link_href(link)
    if link.wiki?
      wiki_path(link.wiki_page)
    else
      link.href
    end
  end

  def random_comment_motivation_prefix
    ['Стань частью книги',
     'Попробуй новый лит. формат',
     'Узнай о мире больше'].sample + ' — '
  end

  def random_comment_motivation_postfix
    ['спроси героя', 'оставь комментарий', 'общайся с героем'].sample
  end

end
