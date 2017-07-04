class Item < ApplicationRecord
  belongs_to :shopping_list, optional: true

  def nice_quant
    if p = Product.find_by(nickname: self.name)
      if p.line_items.where('line_items.weight IS NOT NULL').empty?
        quantity.to_i
      else
        "#{quantity} lb"
      end
    else
      val = quantity
      val == val.to_i ? val.to_i : "#{val} lb"
    end
  end
end
