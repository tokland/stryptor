class StripsController < ApplicationController
  def index
    collection = StripCollection.find_by_param!(params[:strip_collection_id])
    redirect_to(strip_path(collection.strips.by_code(:asc).first!))
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
