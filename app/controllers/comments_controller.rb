class CommentsController < ApplicationController
  before_filter :only_for_author, only: :index

  def index
  end

  def create
    comment = Comment.new
    comment.chapter      = params[:chapter]
    comment.author_name  = params[:name]
    comment.author_email = params[:email]
    comment.author_ip    = request.remote_ip
    comment.text         = params[:text]
    comment.comment_for  = params[:for_author] ? 'author' : 'hero'

    if comment.save
      respond_to do |format|
        format.html { redirect_to params[:return_to] }
        format.json { head :ok }
      end
    else
      render text: comment.errors.full_messages.join("\n"), status: :bad_request
    end
  end

end
