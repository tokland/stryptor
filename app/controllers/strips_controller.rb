class StripsController < ApplicationController
  def index
    strip = Strip.first_by_params!(params)
    redirect_to(strip_path(strip))
  end
  
  def show
    render_strip(Strip.find_by_params!(params))
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
