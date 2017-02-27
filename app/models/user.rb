class User < ApplicationRecord
  enum role: [:user, :admin]
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:google_oauth2]
  has_many :baskets
  has_many :shopping_lists
  has_many :line_items, through: :baskets
  has_many :products,through: :line_items
  has_many :nick_name_requests
  validates :name, presence: true

  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :user
  end

  def self.from_omniauth(auth)
    data = auth.info
    if user = User.where(email: data["email"]).first
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      if auth.credentials.refresh_token
        user.oauth_refresh_token = auth.credentials.refresh_token
      end
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user
    end
  end
end
