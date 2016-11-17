class ChangeColumnTypeInBaskets < ActiveRecord::Migration[5.0]
  def change
    change_column :baskets, :date, :datetime
  end
end
