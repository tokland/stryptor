class StripsController < ApplicationController
  def index
    strip = Strip.first_by_params!(params)
    redirect_to(strip_path(strip))
  end
  
  def show
    @strip = Strip.find_by_params!(params)
    @pagination = @strip.pagination
    render(:show)
  end
  
  def random
    collection = StripCollection.find_by_param!(params[:strip_collection_id])
    redirect_to(strip_path(collection.strips.random))
  end
end
