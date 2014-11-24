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
    redirect_to(strip_path(Strip.random))
  end
end
