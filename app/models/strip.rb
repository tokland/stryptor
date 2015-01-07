class Strip < ActiveRecord::Base
  include PgSearch
  include UsesParam
  
  Pagination = Struct.new(:index, :total, :first, :previous, :next, :last)

  belongs_to :strip_collection
  has_attached_file :image, default_url: proc { |image| image.instance.image_url }
  has_many :transcripts, inverse_of: :strip, dependent: :destroy
  has_many :votes, dependent: :destroy, as: :voteable
    
  validates :strip_collection, presence: true
  validates :position, presence: true, uniqueness: {scope: :strip_collection_id} 
  validates :code, presence: true, uniqueness: {scope: :strip_collection_id}
  validates_attachment :image, content_type: {content_type: ["image/jpeg"]}
  
  scope :by_position, proc { order(Strip[:position].asc) }
  scope :without_transcriptions, proc { where(Strip[:text] == nil) }
  scope :with_transcriptions, proc { where(Strip[:text] ^ nil) }

  uses_param :code
  pg_search_scope :search, against: :text, ignoring: :accents
  
  def self.random
    strips = Strip.without_transcriptions.presence || Strip.all 
    strips.offset(rand(strips.count)).first!
  end
  
  def self.find_by_params!(params)
    collection = StripCollection.find_by_param!(params[:strip_collection_id])
    collection.strips.find_by_param!(params[:id])
  end

  def self.transcribed_today
    from = Time.now.beginning_of_day
    Strip.joins(:transcripts).where(Transcript[:created_at] >= from).uniq
  end

  def image_url
    strip_collection.image_url % {code: code}
  end

  def current_transcript
    transcripts.order(Transcript[:created_at].desc).first    
  end
  
  def title
    "%{collection} %{strip}" % {collection: strip_collection.name, strip: code}
  end
  
  def form_transcript(anonuser_name)
    transcripts.new(text: text, anonuser_name: anonuser_name)
  end
  
  def pagination
    strips = strip_collection.strips
    Pagination.from_hash(
      index: position,
      total: strips.count,
      first: strips.first,
      last: strips.last,
      next: strips.where(Strip[:position] > position).first,
      previous: strips.where(Strip[:position] < position).last,
    )
  end
  
  def vote_by(user) 
    user ? user.votes.find_by(voteable: self) : nil
  end
end
