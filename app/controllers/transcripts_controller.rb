class TranscriptsController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    @transcript = Transcript.new_from_params(current_user, params)
    
    if @transcript.save
      redirect_to(@transcript.strip)
    else
      error_message = @transcript.errors.full_messages.to_sentence
      redirect_to(@transcript.strip, :alert => "Error saving: #{error_message}")
    end
  end
end
