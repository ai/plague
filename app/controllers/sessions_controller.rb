class SessionsController < ApplicationController

  def create
    auth   = request.env['omniauth.auth']
    author = story['author_email']
    if author != auth['user_info']['email']
      flash[:wrong_signin] = true
    else
      session[:session_token] = Session.author_session.token
    end
    redirect_to request.env['omniauth.origin'] || root_path
  end

  def destroy
    user_session.generate_token!
    session.delete :session_token
    redirect_to request.referer || root_path
  end

end
