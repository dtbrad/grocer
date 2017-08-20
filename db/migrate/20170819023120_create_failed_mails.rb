class CreateFailedMails < ActiveRecord::Migration[5.0]
  def change
    create_table :failed_mails do |t|
      t.jsonb :data
      t.timestamps
    end
  end
end
