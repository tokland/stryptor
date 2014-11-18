class Transcript < ActiveRecord::Base
  belongs_to :strip
  belongs_to :user
  
  validates :text, presence: true
  validates :strip, presence: true
  validates :user, presence: true
  
  def self.new_from_params(user, params)
    strip = Strip.find_by!(code: params[:strip_id])
    text = params[:transcript].maybe[:text].strip.value
    strip.transcripts.new(text: text, user: user)
  end
end
