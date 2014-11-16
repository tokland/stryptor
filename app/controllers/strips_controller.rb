class StripsController < ApplicationController
  def show
    @strip = Strip.find_by_code!(params[:id])
    @pagination = Strip.pagination(@strip)
  end
  
  def random
    @strip = Strip.random
    @pagination = Strip.pagination(@strip)
    render :action => :show
  end
end
