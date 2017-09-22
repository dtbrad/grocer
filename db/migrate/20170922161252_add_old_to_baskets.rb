class AddOldToBaskets < ActiveRecord::Migration[5.0]
  def change
    add_column :baskets, :old, :boolean, default: false
  end
end
