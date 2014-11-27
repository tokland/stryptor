class StripsController < ApplicationController
  PaginationOptions = {:default => 20, :min => 1, :max => 50}
  
  def index
    strip = Strip.first_by_params!(params)
    redirect_to(strip_path(strip))
  end
  
  def show
    @strip = Strip.find_by_params!(params)
    @pagination = @strip.pagination
  end
  
  def random
    collection = StripCollection.find_by_param!(params[:strip_collection_id])
    redirect_to(strip_path(collection.strips.random))
  end
  
  def search
    @strip_collection = StripCollection.find_by_param!(params[:strip_collection_id])
    all_strips = @strip_collection.strips.by_code(:asc)
    po = PaginationOptions
    per_page = [[(params[:per_page] || 20).to_i, po[:max]].min, po[:min]].max
    @strips = all_strips.search(params[:text]).page(params[:page]).per(per_page)
  end
end
