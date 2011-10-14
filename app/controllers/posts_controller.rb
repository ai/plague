class PostsController < ApplicationController
  def title
    @title = Post.new('title/title')
    render 'title/title'
  end

  def show
  end
end
