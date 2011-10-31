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
    @post = Post.by_url params[:path]

    draft = params[:draft]
    raise Post::NotFound if @post.draft? and @post.attrs['draft'] != draft
  end

  private

  def load_title
    @title = Post.new('title')
    @first = @title.next
  end
end
