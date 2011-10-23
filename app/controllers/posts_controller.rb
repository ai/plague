class PostsController < ApplicationController
  def title
    @title = Post.new('title')
    render 'title/title'
  end

  def show
    @post = Post.by_url params[:path]
  end
end
