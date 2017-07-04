class ShoppingList < ApplicationRecord
  has_many :items, dependent: :destroy
  belongs_to :user, optional: true
  accepts_nested_attributes_for :items

  def total
    items.sum('items.price * items.quantity')
  end
end
