class Strip < ActiveRecord::Base
  Pagination = Struct.new(:index, :total, :first, :previous, :next, :last)
  
  has_many :transcripts, inverse_of: :strip, dependent: :nullify 
  has_attached_file :image
  validates_attachment :image, content_type: {content_type: ["image/jpeg"]}
  scope :by_code_asc, proc { order(Strip[:code].asc) }
  scope :by_code_desc, proc { order(Strip[:code].desc) }
  
  def to_param
    code
  end

  def current_transcript
    transcripts.order(Transcript[:created_at].desc).first    
  end
  
  def current_text
    current_transcript.try(:text)
  end
  
  def image_url
    filename = "mafalda-%s.jpg" % File.basename(code).sub(/-/, '_')
    URI.join("http://mafalda.zaudera.com/images/", filename) 
  end
  
  def title
    "Mafalda #{code}"
  end
  
  def self.random
    offset(rand(Strip.count)).first
  end
  
  def pagination
    Pagination.from_hash(
      index: position,
      total: Strip.count,
      first: Strip.by_code_asc.first,
      last:  Strip.by_code_desc.first,
      previous: Strip.by_code_desc.where(Strip[:code] < code).first,
      next: Strip.by_code_asc.where(Strip[:code] > code).first,
    )
  end
end
