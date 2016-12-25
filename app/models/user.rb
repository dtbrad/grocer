class User < ApplicationRecord
  has_many :baskets
  has_many :line_items, through: :baskets
  has_many :products, -> { distinct },through: :line_items
  validates :name, presence: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.email = auth.info.email
      user.image = auth.info.image
      if auth.credentials.refresh_token
        user.oauth_refresh_token = auth.credentials.refresh_token
      end
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end
end
