class Transcript < ActiveRecord::Base
  belongs_to :strip
  belongs_to :user
  
  validates :text, presence: true
  validates :strip, presence: true
  validates :user, presence: true
  
  scope :by_version, proc { |key| order(Transcript[:created_at].send(key)) }
  
  def self.new_from_params(user, params)
    strip = Strip.find_by!(code: params[:strip_id])
    text = params[:transcript].maybe[:text].strip.value
    strip.transcripts.new(text: text, user: user)
  end
  
  def info
    {strip => strip.to_param, :user => user.name, :text => text, :created_at => created_at}
  end
end
