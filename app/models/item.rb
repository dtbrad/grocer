class Item < ApplicationRecord
  belongs_to :shopping_list, :optional => true

  def nice_quant
    if p = Product.find_by(nickname: self.name)
      if p.line_items.where('line_items.weight IS NOT NULL').empty?
        self.quantity.to_i
      else
        "#{self.quantity} lb"
      end
    else
      val = self.quantity
      val == val.to_i ? val.to_i : "#{val} lb"
    end
  end

end
