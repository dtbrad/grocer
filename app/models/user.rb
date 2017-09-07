class User < ApplicationRecord
  enum role: %i[user admin]
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  has_many :baskets
  has_many :shopping_lists
  has_many :line_items, through: :baskets
  has_many :products, through: :line_items
  has_many :nick_name_requests
  has_many :google_mail_objects
  has_many :mailgun_messages
  validates :name, presence: true
  # validates :name, uniqueness: true

  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :user
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first
    unless user
      name = User.find_by(name: data['name']) ? data['email'] : data['name']
      user = User.new(
        name: name, email: data['email'], password: Devise.friendly_token[0, 20], fresh: false, confirmed_at: Time.now
      )
      user.save

    end
    user
  end

  def exclusive_products
    query = "
              SELECT user_id, COUNT(*) AS my_result
              FROM  (
              SELECT max(user_id) AS user_id, l1.product_id
              FROM   line_items l1
              INNER  JOIN baskets b1 ON l1.basket_id = b1.id
              GROUP  BY l1.product_id
              HAVING COUNT(DISTINCT b1.user_id) = 1
              ) p1
              GROUP  BY user_id
              HAVING user_id = ?
            "
    result = LineItem.execute_with_params(query, id)
    result.field_values('my_result').empty? ? 0 : result[0]['my_result']
  end
end
