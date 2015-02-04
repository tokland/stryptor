class TranscriptsController < ApplicationController
  AntiSpamToken = "1234"
  
  before_filter :check_antispam_token, :only => :create
  
  def index
    @strip_collection = StripCollection.find_by_param!(params[:strip_collection_id]) 

    respond_to do |format|
      if params[:strip_id]
        strip = @strip_collection.strips.find_by_param!(params[:strip_id])
        format.html { redirect_to(strip_path(strip)) }
      else
        @transcripts = @strip_collection.transcripts.by_version(:desc).
          includes(:strip_collection, :strip).page(params[:page]).per(100)
        format.html 
      end
    end
  end
  
  def show
    strip = Strip.find_by_params!(params)
    
    respond_to do |format|
      format.json { render(:json => transcript.info) }
    end
  end
  
  def create
    @transcript = Transcript.from_request(params, request.ip, current_user)
    
    if @transcript.save
      session[:anonuser_name] = @transcript.anonuser_name
      redirect_to(strip_path(@transcript.strip))
    else
      error_message = @transcript.errors.full_messages.to_sentence
      redirect_to(strip_path(@transcript.strip), :alert => error_message)
    end
  end

private

  def check_antispam_token
    unless params[:token] == AntiSpamToken
      render :status => :forbidden, :text => "Forbidden"
    end
  end
end
