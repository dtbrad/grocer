class ProductSerializer < ActiveModel::Serializer
  attributes :name, :nickname, :price

  def price
    (object.highest_price_cents.to_f) / 100 unless !object.has_line_items?
  end

end
