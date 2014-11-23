class TranscriptsController < ApplicationController
  before_filter :authenticate_user!, :only => :create
  
  def show
    strip = Strip.find_by_params!(params)
    
    respond_to do |format|
      format.json { render :json => transcript.info }
    end
  end
  
  def create
    @transcript = Transcript.from_params(current_user, params)
    
    if @transcript.save
      redirect_to(strip_path(@transcript.strip))
    else
      error_message = @transcript.errors.full_messages.to_sentence
      redirect_to(strip_path(@transcript.strip), :alert => error_message)
    end
  end
end
