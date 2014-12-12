class Transcript < ActiveRecord::Base
  belongs_to :strip, counter_cache: true
  belongs_to :user
  
  after_commit :update_strip_text
  
  validates :strip, presence: true
  validates :text, presence: true
  
  scope :by_version, proc { |key| order(Transcript[:created_at].send(key)) }
  
  def created_at
    read_attribute(:created_at).maybe.in_time_zone("Madrid").value
  end

  def user_name
    (user ? user.name : anonuser_name) || "Anónimo" 
  end
  
  def update_strip_text
    new_text = strip.current_transcript.maybe.text.value
    strip.update_attributes(:text => new_text)
  end
  
  def self.find_by_params!(params)
    strip = Strip.find_by_params!(params)
    strip.transcripts.find(params[:id])
  end
  
  def self.from_request(request, user)
    params = request.params
    collection = StripCollection.find_by_param!(params[:strip_collection_id])
    strip = collection.strips.find_by_param!(params[:strip_id])
    new_text = params[:transcript].maybe[:text].strip.value
    
    if strip.text && strip.text == new_text && strip.current_transcript
      strip.current_transcript
    elsif user
      strip.transcripts.new(text: new_text, user: user)
    else
      anonuser_name = params[:transcript].maybe[:anonuser_name].strip.value
      strip.transcripts.new(
        text: new_text,
        anonuser_ip: request.ip, 
        anonuser_name: anonuser_name,
      )
    end
  end
  
  def info
    {strip: strip.to_param, user: user.name, text: text, date: created_at}
  end
end
