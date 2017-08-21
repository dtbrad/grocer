class GoogleMailObject < ApplicationRecord
  belongs_to :user
  has_many :baskets
  validates :date, uniqueness: { scope: :user }

  def json_data
    JSON.parse(data)
  end

  def delivered_to
    email = json_data["payload"]["headers"].find{|h| h["name"] == 'Delivered-To' }["value"]
    User.find_by(email: email)
  end

  def decoded_body
    body = json_data["payload"]["body"]["data"]
    Base64.urlsafe_decode64(body)
  end
end
