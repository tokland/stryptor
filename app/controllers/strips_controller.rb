class StripsController < ApplicationController
  PaginationOptions = {:default => 20, :min => 1, :max => 50}
  respond_to :html
  
  def index
    collection = StripCollection.find_by_param!(params[:strip_collection_id])
    strip = collection.strips.first!
    redirect_to(strip_path(strip))
  end
  
  def show
    @strip = Strip.find_by_params!(params)
    @pagination = @strip.pagination
    @vote = current_user.maybe.votes.find_by(voteable: @strip).__value__
  end
  
  def random
    collection = StripCollection.find_by_param!(params[:strip_collection_id])
    redirect_to(strip_path(collection.strips.random))
  end
  
  def search
    @strip_collection = StripCollection.find_by_param!(params[:strip_collection_id])
    po = PaginationOptions
    @per_page = (params[:per_page] || po[:default]).to_i.clip(po[:min], po[:max])
    @strips = @strip_collection.strips.search(params[:text]).
      page(params[:page]).per(@per_page)
  end
end
