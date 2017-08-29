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
    body = if json_data["payload"]["parts"]
             json_data["payload"]["parts"][0]["body"]["data"]
           else
             json_data["payload"]["body"]["data"]
           end
    Base64.urlsafe_decode64(body)
  end

  def make_shopping_data
    email = { date: date, body: body, user: user }
    email_data = EmailDataProcessor.new(email)
    email_data.process_single_email
  end

  def set_date
    date_string = body[/(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) [0-9]{1,2}, \d{4} [0-9]{1,2}:[0-9]{1,2}:[0-9]{1,2} (A|P)M/]
    self.date = DateTime.parse(date_string)
  end
end
