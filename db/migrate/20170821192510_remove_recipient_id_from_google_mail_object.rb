class RemoveRecipientIdFromGoogleMailObject < ActiveRecord::Migration[5.0]
  def change
    remove_column :google_mail_objects, :recipient_id
  end
end
