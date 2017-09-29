class ChangeColumnNameAgainInLineItems < ActiveRecord::Migration[5.0]
  def change
    rename_column :line_items, :basket_date, :transaction_date
  end
end
