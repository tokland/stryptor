class StripCollection < ActiveRecord::Base
  include UsesParam
  
  has_many :strips, {dependent: :destroy}, proc { order(Strip[:position].asc) }
  has_many :transcripts, through: :strips
  
  validates :code, presence: true, uniqueness: true
  validates :image_url, presence: true
  validates :footer, presence: true
  
  uses_param :code
end
