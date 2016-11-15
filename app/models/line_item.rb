class LineItem < ApplicationRecord
  belongs_to :basket
  belongs_to :product

  monetize :price_cents
end
