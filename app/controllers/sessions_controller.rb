class SessionsController < ApplicationController
  def new
    redirect_to('/auth/facebook')
  end

  def create
    auth = request.env["omniauth.auth"]
    existing_user = User.find_by(provider: auth['provider'], uid: auth['uid'].to_s)
    user = existing_user || User.create_with_omniauth!(auth)
    reset_session
    session[:user_id] = user.id
    redirect_to(root_url, notice: 'Signed in!')
  end

  def destroy
    reset_session
    redirect_to(root_url, notice: 'Signed out!')
  end

  def failure
    msg = "Authentication error: #{params[:message].humanize}"
    redirect_to(root_url, alert: msg)
  end
end
