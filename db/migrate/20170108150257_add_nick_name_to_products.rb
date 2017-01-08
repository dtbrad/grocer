class AddNickNameToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :nickname, :string
  end
end
