class AddColumnsToGoogleMailObject < ActiveRecord::Migration[5.0]
  def change
    add_column :google_mail_objects, :date, :datetime
    add_column :google_mail_objects, :recipient_id, :integer
    add_column :google_mail_objects, :delivered_to, :string
  end
end
