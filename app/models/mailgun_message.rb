class MailgunMessage < ApplicationRecord
  belongs_to :user
  after_initialize :set_user, if: :new_record?
  after_initialize :set_date, if: :new_record?
  validates :date, uniqueness: { scope: :user }

  def finalize
    if valid?
      save
      self
    else
      MailgunMessage.find_by_date_and_user_id(date, user_id)
    end
  end

  def body
    data["body-html"]
  end

  def forwarded_via_gmail_filter?
    !data["Delivered-To"].nil?
  end

  def recipient
    forwarded_via_gmail_filter? ? data["Delivered-To"] : data["X-Envelope-From"].delete('<>')
  end

  def shoppers_name
    data["From"].split(" <")[0]
  end

  def set_date
    date_string = body[/(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) [0-9]{1,2}, \d{4} [0-9]{1,2}:[0-9]{1,2}:[0-9]{1,2} (A|P)M/]
    self.date = DateTime.parse(date_string)
  end

  def set_user
    if !User.find_by(email: recipient).nil?
      self.user = User.find_by(email: recipient)
    else
      self.user = User.create(email: recipient, name: shoppers_name, password: Devise.friendly_token.first(6),
                              generated_from_email: true)
    end
  end
end
