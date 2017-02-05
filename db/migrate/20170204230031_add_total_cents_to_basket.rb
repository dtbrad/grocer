class AddTotalCentsToBasket < ActiveRecord::Migration[5.0]
  def change
    add_column :baskets, :total_cents, :integer
  end
end
