# encoding: utf-8
module LayoutHelper

  def include_jquery
    if Rails.env.production?
      url = 'https://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js'
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
    ['//fonts.googleapis.com/css?family=Philosopher&subset=cyrillic',
     '//fonts.googleapis.com/css?family=PT+Sans:400,700&subset=cyrillic,latin'].
      map { |i| stylesheet_link_tag(i, media: 'all', type: nil) }.
      join("\n").html_safe
  end

  def title(*titles)
    content_for(:title) { titles.join(' — ') }
  end

end
