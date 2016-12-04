class ChangeColumTypeInLineItems < ActiveRecord::Migration[5.0]
  def change
    change_column :line_items, :quantity, :decimal
  end
end
