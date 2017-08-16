class AddGeneratedFromEmailColumnToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :generated_from_email, :boolean, default: false
    add_column :users, :changed_password, :integer, default: 0
  end
end
