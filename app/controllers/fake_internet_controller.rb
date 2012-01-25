class FakeInternetController < ApplicationController
  caches_page :wiki, :speakandrelax

  layout 'simple'

  def wiki
    Post.each do |post|
      if post.wikis.has_key? params[:page]
        @post = post
        break
      end
    end

    raise Post::NotFound unless @post

    @wiki = @post.wikis[params[:page]]
  end
end
