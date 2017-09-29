class AddDateToLineItems < ActiveRecord::Migration[5.0]
  def change
    add_column :line_items, :date, :datetime
  end
end
