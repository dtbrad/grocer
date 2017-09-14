class AddTaxCentsToBaskets < ActiveRecord::Migration[5.0]
  def change
    add_column :baskets, :tax_cents, :integer
  end
end
