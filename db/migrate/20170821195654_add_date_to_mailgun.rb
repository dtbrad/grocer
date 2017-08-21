class AddDateToMailgun < ActiveRecord::Migration[5.0]
  def change
    add_column :mailgun_messages, :date, :datetime
  end
end
