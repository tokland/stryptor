class Transcript < ActiveRecord::Base
  belongs_to :strip
  belongs_to :user
  
  validates :strip, presence: true
  validates :user, presence: true
  
  def self.new_from_params(user, params)
    transcript_params = params.require(:transcript).permit(:text)
    strip = Strip.find_by_code!(params[:strip_id])
    transcript = strip.transcripts.new(transcript_params)
    transcript.user = user
    [strip, transcript] 
  end
end
