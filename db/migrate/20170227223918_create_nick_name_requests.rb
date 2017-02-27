class CreateNickNameRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :nick_name_requests do |t|
      t.string :suggestion
      t.integer :product_id
      t.integer :user_id
      t.integer :status

      t.timestamps
    end
  end
end
