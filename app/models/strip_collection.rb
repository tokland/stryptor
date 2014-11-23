class StripCollection < ActiveRecord::Base
  has_many :strips, dependent: :nullify
  validates :code, presence: true, uniqueness: true
  validates :image_url, presence: true
  
  def self.find_by_param!(value)
    StripCollection.find_by!(code: value)
  end

  def to_param
    code
  end
end
