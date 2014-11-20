class TranscriptsController < ApplicationController
  before_filter :authenticate_user!, :only => :create
  
  def show
    strip = Strip.find_by_param!(params[:strip_id])
    transcript = strip.transcripts.find(params[:id])
    
    respond_to do |format|
      format.json { render :json => transcript.info }
    end
  end
  
  def create
    @transcript = Transcript.from_params(current_user, params)
    obj = [@transcript.strip.strip_collection, @transcript.strip]
    
    if @transcript.save
      redirect_to(obj)
    else
      error_message = @transcript.errors.full_messages.to_sentence
      redirect_to(obj, :alert => "Error saving: #{error_message}")
    end
  end
end
