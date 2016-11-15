class Product < ApplicationRecord
  has_many :line_items
  has_many :baskets, through: :line_items
end
