class PostsController < ApplicationController
  before_filter :load_title, only: %w(title all)

  caches_page_with_gzip :all, :feed, :show, :wiki
  caches_page_with_gzip :title, if: :new_reader?

  def title
  end

  def all
    @all_posts = true
    html = render_to_string 'title', layout: false
    @post = @first
    while @post
      html += render_to_string 'show', layout: false
      @post = @post.next
    end
    render text: html
  end

  def feed
    @entries = Post.all_with_important_comments
    Haml::Template.options[:format] = :xhtml
    render layout: false
  end

  def show
    @post = Post.by_url("/#{params[:path]}")
  end

  def story
    redirect_to Post.first_in_story(params[:story]).url
  end

  def update
    if params['key'] == story_config['api_key']
      Post.update_repository!
      expire_all
      render text: 'updated'
    else
      render text: 'wrong key', status: :bad_request
    end
  end

  def wiki
    Post.each do |post|
      logger.debug post.wikis.keys
      if post.wikis.has_key? params[:page]
        @post = post
        break
      end
    end

    raise Post::NotFound unless @post

    @wiki = @post.wikis[params[:page]]
    render :wiki, layout: 'simple'
  end

  def start
    redirect_to Post.first.url
  end

  private

  def load_title
    @title = Post.title
    @first = Post.first
    @last  = Post.last
    if cookies[:reading] and not @all_posts
      begin
        @reading      = Post.by_url(cookies[:reading])
        @reading_last = cookies['reading-last']
        @new_post     = @reading.next if @reading_last
      rescue Post::NotFound
        cookies.delete('reading')
        cookies.delete('reading-last')
      end
    end
  end

  def new_reader?
    cookies[:reading].nil?
  end
end
