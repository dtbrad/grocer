class AddRealUnitPriceCentsToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :real_unit_price_cents, :integer
  end
end
