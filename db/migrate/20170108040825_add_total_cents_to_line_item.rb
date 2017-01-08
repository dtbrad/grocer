class AddTotalCentsToLineItem < ActiveRecord::Migration[5.0]
  def change
    add_column :line_items, :total_cents, :integer
  end
end
