class AddFreshToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :fresh, :boolean, default: true
  end
end
