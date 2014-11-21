class StripCollection < ActiveRecord::Base
  has_many :strips, dependent: :nullify
  validates :code, uniqueness: true
  
  def self.find_by_param!(value)
    StripCollection.find_by!(code: value)
  end

  def to_param
    code
  end
end
