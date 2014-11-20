class StripsController < ApplicationController
  def index
    strip = Strip.by_code(:asc).first
    redirect_to([strip.strip_collection, strip])
  end
  
  def show
    collection = StripCollection.find_by_param!(params[:strip_collection_id])
    strip = collection.strips.find_by_param!(params[:id])
    render_strip(strip)
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
