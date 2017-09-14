class AddSubtotalCentsToBaskets < ActiveRecord::Migration[5.0]
  def change
    add_column :baskets, :subtotal_cents, :integer
  end
end
