# encoding: utf-8
module LayoutHelper

  def include_jquery
    if Rails.env.production?
      url = 'http://yandex.st/jquery/1.7.1/jquery.min.js'
    else
      url = 'development/jquery-1.7.1.js'
    end
    javascript_include_tag(url, type: nil)
  end

  def enable_html5_for_ie
    '<!--[if lt IE 9]>'.html_safe +
      javascript_include_tag('//html5shim.googlecode.com/svn/trunk/html5.js') +
    '<![endif]-->'.html_safe
  end

  def include_fonts
    if Rails.env.production?
      fonts = 'PT+Sans:r,b|Philosopher'
      url   = "//fonts.googleapis.com/css?family=#{fonts}&subset=cyrillic"
      stylesheet_link_tag(url, media: 'all', type: nil)
    else
      stylesheet_link_tag('fonts')
    end
  end

  def title(*titles)
    content_for(:title) { titles.join(' — ') }
  end

  def feed_url
    'http://feeds.feedburner.com/insomnis/feed'
  end

end
