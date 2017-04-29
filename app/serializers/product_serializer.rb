class ProductSerializer < ActiveModel::Serializer
  attributes :name, :nickname, :price, :has_weight

  def price
    (object.highest_price_cents.to_f) / 100 unless !object.has_line_items?
  end

  def has_weight
    if object.line_items.where('line_items.weight IS NOT NULL').empty?
      false
    else
      true
    end
  end

end
