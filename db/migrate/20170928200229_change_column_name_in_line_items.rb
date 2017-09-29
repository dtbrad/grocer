class ChangeColumnNameInLineItems < ActiveRecord::Migration[5.0]
  def change
    rename_column :line_items, :date, :basket_date
  end
end
