class MailgunMessage < ApplicationRecord
  belongs_to :user
  before_validation :set_date, if: :new_record?
  before_validation :set_user, if: :new_record?
  validates_each :to_field, :x_envelope_from_field, :from_field do |record, attr, value|
    record.errors.add(attr, 'invalid email') if record.extract_email(value).nil?
  end
  validates :date, uniqueness: { scope: :user }
  validate :proper_date_format
  before_save :wipe_cc
  before_save :welcome_user

  def wipe_cc
    cc_field = EmailParser.cc_field(body_field)
    body_field.gsub!(cc_field, "CREDIT CARD INFO REMOVED") if cc_field
  end

  def self.process_new_mailgun(params)
    mailgun_message = MailgunMessage.new(params)
    mailgun_message.save ? mailgun_message.package : mailgun_message.handle_invalid(params)
  end

  def proper_date_format
    return if date.is_a?(ActiveSupport::TimeWithZone)
    errors.add(:date, "not a proper date")
  end

  def forwarded_via_filter?
    extract_email(from_field) == "receipts@newseasonsmarket.com"
  end

  def handle_invalid(data)
    return if errors.size == 1 && errors.full_messages.include?("Date has already been taken")
    FailedMail.create(data: data)
    nil
  end

  def package
    { date: date, body: body_field, user: user }
  end

  def welcome_user
    user.send_reset_password_instructions if user.fresh
  end

  def recipient
    forwarded_via_filter? ? extract_email(to_field) : extract_email(x_envelope_from_field)
  end

  def extract_email(value)
    value.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i).first
  end

  def set_date
    date_string = body_field[/(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) [0-9]{1,2}, \d{4} [0-9]{1,2}:[0-9]{1,2}:[0-9]{1,2} (A|P)M/]
    self.date = DateTime.parse(date_string)
  end

  def set_user
    if self.user = User.find_by(email: recipient)
    else
      self.user = User.create(email: recipient, name: recipient, password: Devise.friendly_token.first(6),
                              generated_from_email: true, confirmed_at: DateTime.now)
    end
  end
end
