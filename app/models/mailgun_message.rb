class MailgunMessage < ApplicationRecord
  belongs_to :user
  after_initialize :set_user, if: :new_record?
  after_initialize :set_date, if: :new_record?
  validates :date, uniqueness: { scope: :user }

  def self.process_mailgun(params)
    m = MailgunMessage.new(data: params)
    if m.save
    else
      m = MailgunMessage.find_by_date_and_user_id(m.date, m.user_id)
    end
    { date: m.date, body: m.body, user: m.user } if m
  end

  def body
    data["body-html"]
  end

  def forwarded_via_filter?
    data["From"] == "New Seasons Receipts <receipts@newseasonsmarket.com>"
  end

  def recipient
    forwarded_via_filter? ? data["To"].gsub(/(\<|\>)/, "") : data["X-Envelope-From"].gsub(/(\<|\>)/, "")
  end

  def set_date
    date_string = body[/(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) [0-9]{1,2}, \d{4} [0-9]{1,2}:[0-9]{1,2}:[0-9]{1,2} (A|P)M/]
    self.date = DateTime.parse(date_string)
  end

  def set_user
    if !User.find_by(email: recipient).nil?
      self.user = User.find_by(email: recipient)
    else
      self.user = User.create(email: recipient, name: recipient, password: Devise.friendly_token.first(6),
                              generated_from_email: true, confirmed_at: DateTime.now)
      user.send_reset_password_instructions
    end
  end
end
