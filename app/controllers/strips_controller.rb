class StripsController < ApplicationController
  def index
    redirect_to(Strip.by_code(:asc).first)
  end
  
  def show
    render_strip(Strip.find_by!(code: params[:id]))
  end
  
  def random
    render_strip(Strip.random)
  end
  
private
  
  def render_strip(strip)
    @strip = strip
    @pagination = @strip.pagination
    render(:show)
  end
end
