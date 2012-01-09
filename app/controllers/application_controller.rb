# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  self.page_cache_compression = true

  if Rails.env.production?
    before_filter do
      if Post.actual_cache?
        Post.clear_comments_cache!
      else
        Post.clear_cache!
      end
    end
  else
    before_filter do
      Post.cache = { }
    end
  end

  rescue_from Post::NotFound do
    path = Rails.root.join('public/404.html')
    render file: path, layout: false, status: :not_found
  end

  protected

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
    Post.clear_cache!
  end

  def expire_post(url)
    expire_page('/posts.atom')
    expire_page('/posts.atom.gz')
    expire_page('/posts.html')
    expire_page('/posts.html.gz')
    expire_page(url)
    expire_page(url + '.html.gz')
    Post.clear_cache!
  end
end
