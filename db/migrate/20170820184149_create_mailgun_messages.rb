class CreateMailgunMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :mailgun_messages do |t|
      t.jsonb :data
      t.timestamps
    end
  end
end
