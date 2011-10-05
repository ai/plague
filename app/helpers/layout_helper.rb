module LayoutHelper

  def include_jquery
    if Rails.env.production?
      url = 'http://yandex.st/jquery/1.6.4/jquery.min.js'
    else
      url = 'development/jquery-1.6.4.js'
    end
    javascript_include_tag(url)
  end

  def enable_html5_for_ie
    '<!--[if lt IE 9]>'.html_safe +
      javascript_include_tag('//html5shim.googlecode.com/svn/trunk/html5.js') +
    '<![endif]-->'.html_safe
  end

end
