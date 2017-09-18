class MailgunObject < ApplicationRecord
  include MessageHelper

  def to_field
    data["To"]
  end

  def from_field
    data["From"]
  end

  def x_envelope_from_field
    data["X-Envelope-From"]
  end

  def body_field
    data["body-html"]
  end

  def extract_email(value)
    value.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i).first
  end

  def recipient
    forwarded_via_filter? ? extract_email(to_field) : extract_email(x_envelope_from_field)
  end

  def forwarded_via_filter?
    extract_email(from_field) == Rails.application.config.receipt_email
  end

  def transaction_date
    date_string = transaction_date_string(body_field)
    DateTime.parse(date_string)
  end
end
