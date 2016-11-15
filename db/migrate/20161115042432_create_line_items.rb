class CreateLineItems < ActiveRecord::Migration[5.0]
  def change
    create_table :line_items do |t|
      t.integer :product_id
      t.integer :basket_id
      t.decimal :quantity
      t.decimal :price

      t.timestamps
    end
  end
end
