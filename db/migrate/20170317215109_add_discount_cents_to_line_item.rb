class AddDiscountCentsToLineItem < ActiveRecord::Migration[5.0]
  def change
    add_column :line_items, :discount_cents, :integer
  end
end
