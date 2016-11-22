class Product < ApplicationRecord
  has_many :line_items
  has_many :baskets, through: :line_items

  def times_bought
    line_items.inject(0) { |sum, l| sum + l.quantity }
  end
end
