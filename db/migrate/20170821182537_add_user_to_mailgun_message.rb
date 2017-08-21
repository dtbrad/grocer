class AddUserToMailgunMessage < ActiveRecord::Migration[5.0]
  def change
    add_column :mailgun_messages, :user_id, :integer
  end
end
