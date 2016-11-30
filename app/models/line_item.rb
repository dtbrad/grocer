class LineItem < ApplicationRecord
  belongs_to :basket
  belongs_to :product
  monetize :price_cents
  validates :price_cents, presence: true
  validates :quantity, presence: true

end
