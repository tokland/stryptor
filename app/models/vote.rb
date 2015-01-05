class Vote < ActiveRecord::Base
  Info = Struct.new(:count, :average, :histogram)
  
  belongs_to :user
  belongs_to :voteable, polymorphic: true
  
  validates :value, presence: true,
    numericality: {only_integer: true, greater_than: 0, less_than_or_equal_to: 5}

  validates :voteable, presence: true
  validates :user, uniqueness: {scope: :voteable}

  def self.info
    votes = Vote
    Info.from_hash(
      count: votes.count,
      average: "%0.1f" % votes.average(:value).to_f,
      histogram: votes.pluck(:value).frequency,
    )
  end
  
  def self.from_params(user, voteable_models, params)
    allowed_types = voteable_models.map { |model| model.name.underscore }
    vtype = params[:type].whitelist(allowed_types)
    
    if vtype
      attrs = {voteable_type: vtype.classify, voteable_id: params[:id]}
      vote = user.votes.where(attrs).first_or_initialize
      vote.value = params[:value]
      vote
    else
      raise(ActiveRecord::RecordNotFound)
    end
  end
end
