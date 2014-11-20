class StripsController < ApplicationController
  def index
    strip = Strip.by_code(:asc).first
    redirect_to([strip.strip_collection, strip])
  end
  
  def show
    render_strip(Strip.find_by_params!(params))
  end
  
  def random
    render_strip(Strip.random)
  end
  
private
  
  def render_strip(strip)
    if strip
      @strip = strip
      @pagination = @strip.pagination
      render(:show)
    else
      render nothing: true
    end
  end
end
