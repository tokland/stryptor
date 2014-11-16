class Strip < ActiveRecord::Base
  Pagination = Struct.new(:index, :total, :first, :previous, :next, :last)
  
  has_attached_file :image
  validates_attachment :image, content_type: {content_type: ["image/jpeg"]}
  scope :by_code_asc, -> { order("code ASC") }
  scope :by_code_desc, -> { order("code DESC") }
  
  def to_param
    code
  end
  
  def title
    "Mafalda #{code}"
  end
  
  def self.random
    offset(rand(count)).first
  end
  
  def self.pagination(strip)
    Pagination.from_hash(
      index: strip.position + 1,
      total: Strip.count,
      first: Strip.by_code_asc.first,
      previous: Strip.by_code_desc.where(Strip[:code] < strip.code).first,
      next: Strip.by_code_asc.where(Strip[:code] > strip.code).first,
      last: Strip.by_code_desc.first,
    )
  end
end
