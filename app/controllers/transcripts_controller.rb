class TranscriptsController < ApplicationController
  before_filter :check_antispam_token, :only => :create
  
  def index
    #Strip.joins(:transcripts).where(Transcript[:created_at] >= start_day)
    @transcripts = Transcript.by_version(:desc).page(params[:page]).per(1000)
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
    unless params[:token] == "1234"
      render :status => :forbidden, :text => "Forbidden"
    end
  end
end
