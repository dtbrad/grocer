class Product < ApplicationRecord
  has_many :line_items, dependent: :destroy
  has_many :baskets, through: :line_items
  validates :name, presence: true

  def times_bought
    line_items.inject(0) { |sum, l| sum + l.quantity }
  end

  def highest_price
    line_items.order(:price_cents).last.price
  end

  def lowest_price
    line_items.order(:price_cents).first.price
  end
end
