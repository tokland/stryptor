class TranscriptsController < ApplicationController
  before_filter :authenticate_user! 
  
  def create
    @strip, @transcript = Transcript.new_from_params(current_user, params)
    
    if @transcript.save
      redirect_to(@strip)
    else
      @pagination = @strip.pagination
      render('strips/show') 
    end
  end
end
