class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from Post::NotFound do
    raise ActionController::RoutingError.new('Not Found')
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
      render 'sessions/new', layout: 'simple', status: :forbidden
    end
  end

  def story
    Rails.configuration.story
  end
  helper_method :story

end
