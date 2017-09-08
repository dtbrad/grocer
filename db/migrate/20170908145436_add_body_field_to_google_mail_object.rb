class AddBodyFieldToGoogleMailObject < ActiveRecord::Migration[5.0]
  def change
    add_column :google_mail_objects, :body_field, :text
  end
end
