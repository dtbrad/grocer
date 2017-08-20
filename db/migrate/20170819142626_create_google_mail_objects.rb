class CreateGoogleMailObjects < ActiveRecord::Migration[5.0]
  def change
    create_table :google_mail_objects do |t|
        t.jsonb :data
        t.integer :user_id
      t.timestamps
    end
  end
end
