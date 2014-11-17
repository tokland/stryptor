class User < ActiveRecord::Base
  has_many :transcripts, inverse_of: :user, dependent: :nullify
  
  def self.create_with_omniauth!(auth)
    attrs1 = auth.slice(:provider, :uid)
    attrs2 = auth.fetch("info", {}).slice(:email, :name)
    User.create!(attrs1.merge(attrs2).to_h)
  end
end
