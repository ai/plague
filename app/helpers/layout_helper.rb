# encoding: utf-8
module LayoutHelper

  def include_jquery
    if Rails.env.production?
      url = 'http://yandex.st/jquery/1.7.0/jquery.min.js'
    else
      url = 'development/jquery-1.7.js'
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
      ['Philosopher&subset=cyrillic', 'PT+Sans:400,700&subset=cyrillic,latin'].
        map { |font|
          url = '//fonts.googleapis.com/css?family=' + font
          stylesheet_link_tag(url, media: 'all', type: nil)
        }.join("\n").html_safe
    else
      stylesheet_link_tag('philosopher') + stylesheet_link_tag('ptsans')
    end
  end

  def title(*titles)
    content_for(:title) { titles.join(' — ') }
  end

end
