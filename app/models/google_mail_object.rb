class GoogleMailObject < ApplicationRecord
  belongs_to :user
  has_many :baskets
  before_validation :set_date, if: :new_record?
  validates :date, uniqueness: { scope: :user }
  validate :proper_date_format
  before_save :wipe_cc

  def wipe_cc
    cc_field = EmailParser.cc_field(body_field)
    body_field.gsub!(cc_field, "CREDIT CARD INFO REMOVED") if cc_field
  end

  def self.process_new_gmail(raw_gmail_object)
    google_mail_object = GoogleMailObject.new(user: raw_gmail_object[:user], body_field: raw_gmail_object[:body_field])
    if google_mail_object.save
      google_mail_object.package
    else
      google_mail_object.handle_invalid(raw_gmail_object[:data], raw_gmail_object[:user])
    end
  end

  def package
    { date: date, body: body_field, user: user }
  end

  def handle_invalid(data, user)
    if errors.size == 1 && errors.full_messages.include?("Date has already been taken")
      GoogleMailObject.find_by(date: date, user: user).package
    else
      FailedGmail.create(data: data, user: user)
      nil
    end
  end

  def proper_date_format
    return if date.is_a?(ActiveSupport::TimeWithZone)
    errors.add(:date, "not a proper date")
  end

  def set_date
    date_string = EmailParser.transaction_date(body_field)
    self.date = DateTime.parse(date_string)
  end
end
