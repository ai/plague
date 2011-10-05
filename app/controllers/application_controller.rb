class ApplicationController < ActionController::Base
  protect_from_forgery

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

end
