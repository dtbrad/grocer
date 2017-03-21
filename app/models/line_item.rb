class LineItem < ApplicationRecord
  belongs_to :basket
  belongs_to :product
  has_one :user, through: :basket
  monetize :price_cents, :disable_validation => true
  monetize :total_cents, as: "total"
  monetize :discount_cents, as: "discount"
  validates :price_cents, presence: true
  validates :quantity, presence: true
  paginates_per 10

  def formatted_weight
    "#{weight} lb" unless weight == nil
  end

  def self.total_spent
    self.sum('total_cents')
  end

  def self.custom_sort(category, direction)
    if category == "date_purchased"
      line_items = select('line_items.*').
      joins(:basket).
      order("baskets.date #{direction}")
    elsif LineItem.column_names.include?(category)
      line_items = select('line_items.*').
      order(category + " " + direction)
    else
      line_items = select('line_items.*').
      joins(:basket).
      order("baskets.date desc")
    end
    line_items
  end
end
