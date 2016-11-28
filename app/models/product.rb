class Product < ApplicationRecord
  has_many :line_items
  has_many :baskets, through: :line_items

  def times_bought
    line_items.inject(0) { |sum, l| sum + l.quantity }
  end

  def highest_price
    line_items.order(:price_cents).max.price
  end

  def lowest_price
    line_items.order(:price_cents).min.price
  end
end
