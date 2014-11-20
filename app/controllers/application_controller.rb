class ApplicationController < ActionController::Base
  extend Memoist
  
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :user_signed_in?
  helper_method :strip_path

  private
  
  def current_user
    if session[:user_id]
      User.find(session[:user_id])
    end
  end
  memoize :current_user

  def user_signed_in?
    !!current_user
  end

  def authenticate_user!
    unless current_user
      redirect_to(root_url, :alert => 'You need to sign in for access to this page')
    end
  end

  def strip_path(strip)
    strip ? polymorphic_path([strip.strip_collection, strip]) : nil
  end
end
