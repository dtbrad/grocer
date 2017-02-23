class ShoppingListSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :items
end
