class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string :name
      t.decimal :price
      t.decimal :quantity
      t.integer :shopping_list_id

      t.timestamps
    end
  end
end
