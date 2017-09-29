class ChangeColumnNameInBaskets < ActiveRecord::Migration[5.0]
  def change
    rename_column :baskets, :date, :transaction_date
  end
end
