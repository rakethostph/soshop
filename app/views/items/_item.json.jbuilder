json.extract! item, :id, :item_name, :item_details, :item_old_price, :item_new_price, :item_av_rating, :item_reviews, :item_location, :item_sku, :item_currency_symbol, :item_image, :item_seller_name, :item_url, :created_at, :updated_at
json.url item_url(item, format: :json)
