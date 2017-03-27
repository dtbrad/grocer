class User < ApplicationRecord
  enum role: [:user, :admin]
  devise :database_authenticatable, :registerable, :confirmable,
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

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(:email => data["email"]).first
    unless user
      user = User.create(
        name: data["name"],
        email: data["email"],
        password: Devise.friendly_token[0,20],
        confirmed_at: Time.now
      )
    end
    user
  end
end
