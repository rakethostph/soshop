class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :item_name
      t.text :item_details
      t.decimal :item_old_price
      t.decimal :item_new_price
      t.decimal :item_av_rating
      t.string :item_reviews
      t.string :item_location
      t.string :item_sku
      t.string :item_currency_symbol
      t.string :item_image
      t.string :item_seller_name
      t.string :item_url

      t.timestamps
    end
  end
end
