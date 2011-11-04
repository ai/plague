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

end
