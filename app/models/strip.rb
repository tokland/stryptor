class Strip < ActiveRecord::Base
  Pagination = Struct.new(:index, :total, :first, :previous, :next, :last)

  belongs_to :strip_collection
  has_many :transcripts, inverse_of: :strip, dependent: :nullify 
  has_attached_file :image, 
    :default_url => proc { |image| image.instance.image_url }
    
  validates_attachment :image, content_type: {content_type: ["image/jpeg"]}
  validates :strip_collection, presence: true
  validates :code, presence: true, uniqueness: {scope: :strip_collection_id}
  
  scope :by_code, proc { |key| order(Strip[:code].send(key)) }
  scope :with_transcriptions, proc { where(Strip[:transcripts_count] ^ 0) }
  scope :without_transcriptions, proc { where(Strip[:transcripts_count] == 0) }
  
  def self.random
    Strip.without_transcriptions.sample ||
      Strip.by_code(:asc).offset(rand(Strip.count)).first!
  end
  
  def self.find_by_param!(value)
    Strip.find_by!(code: value)
  end
  
  def self.first_by_params!(params)
    collection = StripCollection.find_by_param!(params[:strip_collection_id])
    collection.strips.by_code(:asc).first!
  end

  def self.find_by_params!(params)
    collection = StripCollection.find_by_param!(params[:strip_collection_id])
    collection.strips.find_by_param!(params[:id])
  end

  def to_param
    code
  end

  def image_url
    strip_collection.image_url % {code: code}
  end

  def current_transcript
    transcripts.order(Transcript[:created_at].desc).first    
  end
  
  def current_text
    current_transcript.maybe.text.value
  end
  
  def title
    "%s %s" % [strip_collection.name, code]
  end
  
  def pagination
    Pagination.from_hash(
      index: position,
      total: Strip.count,
      first: Strip.by_code(:asc).first,
      last: Strip.by_code(:desc).first,
      previous: Strip.by_code(:desc).where(Strip[:code] < code).first,
      next: Strip.by_code(:asc).where(Strip[:code] > code).first,
    )
  end
end
