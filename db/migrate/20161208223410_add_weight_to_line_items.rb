class AddWeightToLineItems < ActiveRecord::Migration[5.0]
  def change
    add_column :line_items, :weight, :decimal
    change_column :line_items, :quantity, :integer
  end
end
