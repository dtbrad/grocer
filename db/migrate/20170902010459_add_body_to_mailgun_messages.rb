class AddBodyToMailgunMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :mailgun_messages, :body, :text
  end
end
