class MailgunMessage < ApplicationRecord
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

  def date
    body = data["body-plain"]
    date_string = body[/(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) [0-9]{1,2}, \d{4} [0-9]{1,2}:[0-9]{1,2}:[0-9]{1,2} (A|P)M/]
    DateTime.parse(date_string).change(sec:0)
  end

  def find_or_create_user
    if User.find_by(email: recipient)
      User.find_by(email: recipient)
    else
      u = User.create(email: recipient, name: shoppers_name, password: Devise.friendly_token.first(6), generated_from_email: true)
      u
    end
  end

end
