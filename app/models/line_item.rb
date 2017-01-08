class LineItem < ApplicationRecord
  belongs_to :basket
  belongs_to :product
  has_one :user, through: :basket
  monetize :price_cents
  monetize :total_cents, as: "total"
  validates :price_cents, presence: true
  validates :quantity, presence: true

  def formatted_weight
    "#{weight} lb" unless weight == nil
  end

  def self.total_spent
    self.sum('total_cents')
  end

end
