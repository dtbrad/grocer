class ShoppingListSerializer < ActiveModel::Serializer
  attributes :id, :name, :total, :created_at
  has_many :items
end
