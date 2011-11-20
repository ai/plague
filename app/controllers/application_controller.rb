class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter do
    Post.cache = { }
  end

  rescue_from Post::NotFound do
    path = Rails.root.join('public/404.html')
    render file: path, layout: false, status: :not_found
  end

  protected

  def self.caches_page_with_gzip(*actions)
    after_filter :gzip_cache, only: actions
    caches_page  *actions
  end

  def author_signed_in?
    @author_signed_in ||= begin
      return false unless session[:session_token]
      Session.author_session.token == session[:session_token]
    end
  end

  def only_for_author
    unless author_signed_in?
      render 'sessions/new', layout: 'simple', status: :forbidden
    end
  end

  def story
    Rails.configuration.story
  end
  helper_method :story

  def expire_all
    config = Rails.application.config
    FileUtils.rm_rf(config.action_controller.page_cache_directory)
  end

  def expire_post(url)
    expire_page('/post.atom')
    expire_page(url)
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
