class GoogleMailObject < ApplicationRecord
  belongs_to :user
  has_many :baskets
  validates :date, uniqueness: { scope: :user }
  after_initialize :set_user, if: :new_record?
  after_initialize :set_date, if: :new_record?

  def json_data
    JSON.parse(data)
  end

  def set_user
    email = json_data["payload"]["headers"].find { |h| h["name"] == 'Delivered-To' }["value"]
    self.user = User.find_by(email: email)
  end

  def body
    body = json_data["payload"]["body"]["data"]
    Base64.urlsafe_decode64(body)
  end

  def set_date
    date_string = body[/(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) [0-9]{1,2}, \d{4} [0-9]{1,2}:[0-9]{1,2}:[0-9]{1,2} (A|P)M/]
    self.date = DateTime.parse(date_string)
  end
end
