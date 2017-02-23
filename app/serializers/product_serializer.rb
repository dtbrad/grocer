class ProductSerializer < ActiveModel::Serializer
  attributes :name, :price

  def price
    (object.highest_price_cents.to_f) / 100
  end

end
