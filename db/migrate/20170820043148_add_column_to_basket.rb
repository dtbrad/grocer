class AddColumnToBasket < ActiveRecord::Migration[5.0]
  def change
    add_column :baskets, :google_mail_object_id, :integer
  end
end
