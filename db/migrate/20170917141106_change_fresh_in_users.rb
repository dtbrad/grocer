class ChangeFreshInUsers < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :fresh, :boolean, default: false
  end
end
