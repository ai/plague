class SessionsController < ApplicationController

  def create
    signin_email  = request.env['omniauth.auth'].info.email
    author_emails = [story_config['author_email'], 'insomnis.story@gmail.com']

    if author_emails.include? signin_email
      session[:session_token] = Session.author_session.token
      cookies[:author] = { value: 1, expires: 1.year.from_now }
    else
      flash[:wrong_signin] = true
    end

    redirect_to request.env['omniauth.origin'] || root_path
  end

  def destroy
    Session.author_session.generate_token!
    session.delete :session_token
    redirect_to request.referer || root_path
  end

end
