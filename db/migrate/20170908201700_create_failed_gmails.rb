class CreateFailedGmails < ActiveRecord::Migration[5.0]
  def change
    create_table :failed_gmails do |t|
      t.jsonb    "data"
      t.timestamps
    end
  end
end
