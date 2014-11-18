class ApplicationController < ActionController::Base
  extend Memoist
  
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :user_signed_in?

  private
  
  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end
  memoize :current_user

  def user_signed_in?
    !!current_user
  end

  def authenticate_user!
    if !current_user
      redirect_to(root_url, :alert => 'You need to sign in for access to this page.')
    end
  end
end
