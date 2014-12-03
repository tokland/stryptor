class StripCollection < ActiveRecord::Base
  has_many :strips, {dependent: :destroy}, proc { order(Strip[:position].asc) }
  
  validates :code, presence: true, uniqueness: true
  validates :image_url, presence: true
  validates :footer, presence: true
  
  def self.find_by_param!(value)
    StripCollection.find_by!(code: value)
  end

  def to_param
    code
  end
end
