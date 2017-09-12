class AddFishyToBaskets < ActiveRecord::Migration[5.0]
  def change
    add_column :baskets, :fishy_total, :boolean
  end
end
