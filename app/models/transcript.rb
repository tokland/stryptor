class Transcript < ActiveRecord::Base
  belongs_to :strip
  belongs_to :user
  
  validates :text, presence: true
  validates :strip, presence: true
  validates :user, presence: true
  
  scope :by_version, proc { |key| order(Transcript[:created_at].send(key)) }
  
  def self.from_params(user, params)
    strip = Strip.find_by_param(params[:strip_id])
    new_text = params[:transcript].maybe[:text].strip.value
    previous_transcript = strip.transcripts.by_version(:desc).first
    if previous_transcript && new_text == previous_transcript.text
      previous_transcript
    else
      strip.transcripts.new(text: new_text, user: user)
    end
  end
  
  def info
    {strip: strip.to_param, user: user.name, text: text, date: created_at}
  end
end
