class Strip < ActiveRecord::Base
  Pagination = Struct.new(:index, :total, :first, :previous, :next, :last)

  belongs_to :strip_collection
  has_many :transcripts, inverse_of: :strip, dependent: :nullify 
  has_attached_file :image
  validates_attachment :image, content_type: {content_type: ["image/jpeg"]}
  validates :strip_collection, presence: true
  scope :by_code, proc { |key| order(Strip[:code].send(key)) }
  
  def self.random
    #Strip.by_code(:asc).offset(rand(Strip.count)).first
    Strip.where(transcripts_count: 0).sample
  end
  
  def self.find_by_param!(value)
    Strip.find_by!(code: value)
  end

  def self.find_by_params!(params)
    collection = StripCollection.find_by_param!(params[:strip_collection_id])
    collection.strips.find_by_param!(params[:id])
  end

  def to_param
    code
  end

  def current_transcript
    transcripts.order(Transcript[:created_at].desc).first    
  end
  
  def current_text
    current_transcript.maybe.text.value
  end
  
  def image_url
    filename = "mafalda-%s.jpg" % File.basename(code).sub(/-/, '_')
    URI.join("http://mafalda.zaudera.com/images/", filename) 
  end
  
  def title
    "Mafalda #{code}"
  end
  
  def pagination
    Pagination.from_hash(
      index: position,
      total: Strip.count,
      first: Strip.by_code(:asc).first,
      last:  Strip.by_code(:desc).first,
      previous: Strip.by_code(:desc).where(Strip[:code] < code).first,
      next: Strip.by_code(:asc).where(Strip[:code] > code).first,
    )
  end
end
