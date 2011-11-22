# encoding: utf-8
class CommentsController < ApplicationController
  before_filter :only_for_author, expect: :create
  before_filter :spam_defence,    only:   :create
  before_filter :load_comment,    only:   %w(destroy publish answer)

  def index
    @posts = Post.all
    render layout: 'simple'
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

  def destroy
    @comment.destroy
    redirect_to comments_path
  end

  def publish
    @comment.publish! params[:important]
    expire_post(@comment.post.url)
    redirect_to comments_path
  end

  def answer
    @comment.answer! params[:answer]
    expire_post(@comment.post.url)
    redirect_to comments_path
  end

private

  def spam_defence
    if params[:shibboleth].present?
      render text: 'Auto spam is not allowed', status: :bad_request
      return
    end
  end

  def load_comment
    @comment = Comment.find(params[:id])
  end

end
