class AddFailedParseColumnToGoogleMailObject < ActiveRecord::Migration[5.0]
  def change
    add_column :google_mail_objects, :failed_parse, :boolean
  end
end
