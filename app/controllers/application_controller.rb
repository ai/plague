# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  unless Rails.env.production?
    before_filter do
      Post.cache = { }
    end
  end

  rescue_from Post::NotFound do
    path = Rails.root.join('public/404.html')
    render file: path, layout: false, status: :not_found
  end

  protected

  def self.caches_page_with_gzip(*args)
    actions, options = args, {}
    actions, options = args[0..-2], args.last if args.last.is_a?(::Hash)
    after_filter({ only: actions }.merge(options)) { |c| c.gzip_cache }
    caches_page *args
  end

  def author_signed_in?
    @author_signed_in ||= begin
      return false unless session[:session_token]
      Session.author_session.token == session[:session_token]
    end
  end

  def only_for_author
    unless author_signed_in?
      if request.xhr?
        render text: 'Доступ запрещён', status: :forbidden
      else
        render 'sessions/new', layout: 'simple', status: :forbidden
      end
    end
  end

  def story_config
    Rails.configuration.story
  end
  helper_method :story_config

  def book_title
    Rails.configuration.story['title']
  end
  helper_method :book_title

  def expire_all
    config = Rails.application.config
    FileUtils.rm_rf(config.action_controller.page_cache_directory)
    Post.cache = { }
  end

  def expire_post(url)
    expire_page('/posts.atom')
    expire_page('/posts.atom.gz')
    expire_page('/posts.html')
    expire_page('/posts.html.gz')
    expire_page(url)
    expire_page(url + '.html.gz')
    Post.cache = { }
  end

  def gzip_cache
    return unless perform_caching

    path = request.path
    file = if path.empty? or path == "/"
      "/index"
    else
      URI.parser.unescape(path.chomp('/'))
    end
    unless (file.split('/').last || file).include? '.'
      file << self.page_cache_extension
    end
    file = page_cache_directory.to_s + file

    File.open(file, 'rb') do |text|
      File.open(file + '.gz', 'wb') do |gziped|
        buf = ""
        gz  = Zlib::GzipWriter.new(gziped, Zlib::BEST_COMPRESSION)
        gz.write(buf) while text.read(16384, buf)
        gz.close
      end
    end
  end
end
