class SessionsController < ApplicationController
  def new
    redirect_to('/auth/facebook')
  end

  def create
    auth = request.env["omniauth.auth"]
    existing_user = User.find_by(provider: auth['provider'], uid: auth['uid'].to_s)
    user = existing_user || User.create_with_omniauth!(auth)
    redirect_url = stored_url
    reset_session
    session[:user_id] = user.id
    redirect_to(redirect_url, notice: 'Signed in!')
  end

  def destroy
    redirect_url = stored_url
    reset_session
    redirect_to(redirect_url, notice: 'Signed out!')
  end

  def failure
    message = params[:message] || "Unknown error"
    redirect_to(stored_url, alert: "Authentication error: #{message.humanize}")
  end
end
