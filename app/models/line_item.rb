class LineItem < ApplicationRecord
  belongs_to :basket
  belongs_to :product
  has_one :user, through: :basket
  monetize :price_cents
  validates :price_cents, presence: true
  validates :quantity, presence: true

  def formatted_weight
    "#{weight} lb" unless weight == nil
  end

  def total
    weight == nil ? quantity * price : weight * price
  end

end
