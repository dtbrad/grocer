class AddUserToFailedgmail < ActiveRecord::Migration[5.0]
  def change
    add_column :failed_gmails, :user_id, :integer
  end
end
