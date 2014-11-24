class StripCollection < ActiveRecord::Base
  has_many :strips, dependent: :nullify
  has_attached_file :image
  
  validates :code, presence: true, uniqueness: true
  validates :image_url, presence: true
  validates_attachment :image, content_type: {content_type: ["image/png", "image/gif"]} 
  
  def self.find_by_param!(value)
    StripCollection.find_by!(code: value)
  end

  def to_param
    code
  end
end
