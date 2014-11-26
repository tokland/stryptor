class Transcript < ActiveRecord::Base
  belongs_to :strip, counter_cache: true
  belongs_to :user
  
  after_save :update_strip_text
  
  validates :strip, presence: true
  validates :text, presence: true
  validates :user, presence: true
  
  scope :by_version, proc { |key| order(Transcript[:created_at].send(key)) }

  def update_strip_text
    strip.update_attributes(:text => text)
  end
  
  def self.find_by_params!(params)
    strip = Strip.find_by_params!(params)
    strip.transcripts.find(params[:id])
  end
  
  def self.from_params(user, params)
    collection = StripCollection.find_by_param!(params[:strip_collection_id])
    strip = collection.strips.find_by_param!(params[:strip_id])
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
