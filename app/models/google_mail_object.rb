class GoogleMailObject < ApplicationRecord
  belongs_to :user
  has_many :baskets
  validates :date, uniqueness: { scope: :user }

  def date
    j = JSON.parse(data)
    date_string = j["payload"]["headers"].find{|h| h["name"] == "Date"}["value"]
    DateTime.parse(date_string).change(sec:0) - 7.hours
  end

  def delivered_to
    j = JSON.parse(data)
    email = j["payload"]["headers"].find{|h| h["name"] == 'Delivered-To' }["value"]
    User.find_by(email: email)
  end
end
