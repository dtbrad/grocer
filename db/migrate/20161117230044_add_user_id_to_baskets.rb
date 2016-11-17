class AddUserIdToBaskets < ActiveRecord::Migration[5.0]
  def change
    add_column :baskets, :user_id, :integer
  end
end
