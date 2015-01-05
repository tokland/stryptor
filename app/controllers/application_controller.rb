class ApplicationController < ActionController::Base
  extend Memoist
  
  before_filter :load_current_user
  before_filter :store_location
  
  protect_from_forgery with: :exception
  helper_method :current_user, :user_signed_in?, :strip_path
  attr_reader :current_user
  layout nil
  
  def index
    collection = StripCollection.first!
    redirect_to(strip_path(collection.strips.first!))
  end
  
  private

  def store_location
    case
    when params[:redirect_url]
      session[:redirect_url] = params[:redirect_url]
    when request.get? && controller_name != "sessions"
      session[:redirect_url] = request.fullpath
    end
  end
  
  def stored_url
    session[:redirect_url] || root_path
  end
   
  def load_current_user
    @current_user = session[:user_id] ? User.find_by_id(session[:user_id]) : nil
  end

  def user_signed_in?
    !!current_user
  end

  def authenticate_user!
    unless user_signed_in?
      redirect_to(root_url, :alert => 'You need to sign in for access to this page')
    end
  end

  def strip_path(strip)
    strip ? polymorphic_path([strip.strip_collection, strip]) : nil
  end
end
