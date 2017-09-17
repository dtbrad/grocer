class MailgunMessage < ApplicationRecord
  include MessageHelper
  belongs_to :user
  validates_each :to_field, :x_envelope_from_field, :from_field do |record, attr, value|
    record.errors.add(attr, 'invalid email') if record.extract_email(value).nil?
  end
  validates :date, uniqueness: { scope: :user }
  validate :proper_date_format
  before_save -> { wipe_cc(body_field) }

  def self.give_google_forwarding_permission(body)
    url = extract_urls(body).first
    agent = Mechanize.new
    agent.get(url).forms[0].submit
  end

  def proper_date_format
    return if date.is_a?(ActiveSupport::TimeWithZone)
    errors.add(:date, "not a proper date")
  end
end
