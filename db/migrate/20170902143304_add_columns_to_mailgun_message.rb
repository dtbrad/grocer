class AddColumnsToMailgunMessage < ActiveRecord::Migration[5.0]
  def change
    add_column :mailgun_messages, :body_field, :text
    add_column :mailgun_messages, :to_field, :string
    add_column :mailgun_messages, :from_field, :string
    add_column :mailgun_messages, :x_envelope_from_field, :string

  end
end
