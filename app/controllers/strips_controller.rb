class StripsController < ApplicationController
  PaginationOptions = {:default => 20, :min => 1, :max => 50}
  respond_to :html
  
  def index
    collection = StripCollection.find_by_param!(params[:strip_collection_id])
    strip = collection.strips.first!
    
    respond_to do |format|
      format.html { redirect_to(strip_path(strip)) }
      format.json do
        render(
          json: JSON.pretty_generate(collection.strips.by_position.as_json), 
          content_type: 'application/octet-stream',
        )
      end
    end
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
    po = PaginationOptions
    @strip_collection = StripCollection.find_by_param!(params[:strip_collection_id])
    @per_page = (params[:per_page] || po[:default]).to_i.clip_between(po[:min]..po[:max])
    @strips = @strip_collection.strips.search(params[:text]).
      page(params[:page]).per(@per_page)
  end
end
