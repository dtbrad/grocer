class AddFailedParseColumnToMailgunMessage < ActiveRecord::Migration[5.0]
  def change
    add_column :mailgun_messages, :failed_parse, :boolean
  end
end
