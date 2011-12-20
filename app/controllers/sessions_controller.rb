class SessionsController < ApplicationController

  def create
    auth   = request.env['omniauth.auth']
    author = story_config['author_email']
    if author != auth['user_info']['email']
      flash[:wrong_signin] = true
    else
      session[:session_token] = Session.author_session.token
      cookies[:author] = { value: 1, expires: 1.year.from_now }
    end
    redirect_to request.env['omniauth.origin'] || root_path
  end

  def destroy
    Session.author_session.generate_token!
    session.delete :session_token
    redirect_to request.referer || root_path
  end

end
