class AddUserIdToLineItems < ActiveRecord::Migration[5.0]
  def change
    add_column :line_items, :user_id, :integer
  end
end
