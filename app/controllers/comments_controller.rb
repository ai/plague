# encoding: utf-8
class CommentsController < ApplicationController
  before_filter :only_for_author, only: :index

  def index
  end

  def create
    params[:author_name] = 'Аноним' if params[:author_name].strip.empty?

    comment = Comment.new
    comment.post_path    = params[:post_path]
    comment.author_name  = params[:author_name]
    comment.author_email = params[:author_email]
    comment.author_ip    = request.remote_ip
    comment.text         = params[:text]
    comment.comment_for  = params[:for_author] ? 'author' : 'hero'

    session['author_name']  = params[:author_name]
    session['author_email'] = params[:author_email]

    if comment.save
      if request.xhr?
        head :ok
      else
        redirect_to params[:return_to]
      end
    else
      render text: comment.errors.full_messages.join("\n"), status: :bad_request
    end
  end

end
