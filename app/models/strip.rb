class Strip < ActiveRecord::Base
  include PgSearch
  Pagination = Struct.new(:index, :total, :first, :previous, :next, :last)

  belongs_to :strip_collection
  has_many :transcripts, inverse_of: :strip, dependent: :destroy 
  has_attached_file :image, 
    :default_url => proc { |image| image.instance.image_url }
    
  validates :strip_collection, presence: true
  validates :position, presence: true, uniqueness: {scope: :strip_collection_id} 
  validates :code, presence: true, uniqueness: {scope: :strip_collection_id}
  validates_attachment :image, content_type: {content_type: ["image/jpeg"]}
  
  scope :by_code, proc { |key| order(Strip[:code].send(key)) }
  scope :with_transcriptions, proc { where(Strip[:transcripts_count] ^ 0) }
  scope :without_transcriptions, proc { where(Strip[:transcripts_count] == 0) }

  pg_search_scope :search, :against => :text, :ignoring => :accents
  
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
  
  def title
    "%s %s" % [strip_collection.name, code]
  end
  
  def pagination
    strips = strip_collection.strips
    Pagination.from_hash(
      index: position,
      total: strips.count,
      first: strips.by_code(:asc).first,
      last: strips.by_code(:desc).first,
      previous: strips.by_code(:desc).where(Strip[:code] < code).first,
      next: strips.by_code(:asc).where(Strip[:code] > code).first,
    )
  end
end
