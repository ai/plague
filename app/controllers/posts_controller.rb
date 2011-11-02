class PostsController < ApplicationController
  before_filter :load_title, only: %w(title all)

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
    render :text => html
  end

  def show
    @post = Post.by_url("/#{params[:path]}")

    draft = params[:draft]
    raise Post::NotFound if @post.draft? and @post.attrs['draft'] != draft
  end

  def update
    if story['key'] == params['key']
      Post.update_repository!
      render text: 'updated'
    else
      render text: 'wrong key', status: :bad_request
    end
  end

  private

  def load_title
    @title = Post.title
    @first = @title.next
    if cookies[:reading] and not @all_posts
      begin
        logger.debug cookies[:reading].inspect
        @reading      = Post.by_url(cookies[:reading])
        @reading_last = cookies['reading-last']
        @new_post     = @reading.next if @reading_last
      rescue Post::NotFound
        cookies.delete('reading')
        cookies.delete('reading-last')
      end
    end
  end
end
