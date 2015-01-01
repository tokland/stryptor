class User < ActiveRecord::Base
  has_many :transcripts, inverse_of: :user, dependent: :destroy
  has_many :votes, dependent: :destroy
  
  def self.create_with_omniauth!(auth)
    provider_attrs = auth.slice(:provider, :uid)
    info_attrs = auth.fetch("info", {}).slice(:email, :name)
    User.create!(provider_attrs.merge(info_attrs).to_h)
  end
end
