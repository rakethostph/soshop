require 'elasticsearch/model'

class Item < ApplicationRecord

	paginates_per 16

	# belongs_to :affiliate
	after_save :index_items_in_elasticsearch

	include Elasticsearch::Model
  	include Elasticsearch::Model::Callbacks
  	settings do
	    mappings dynamic: false do
			indexes :item_name, type: :text, analyzer: :english
		    indexes :item_details, type: :text, analyzer: :english
		    indexes :item_old_price, type: :integer
		    indexes :item_new_price, type: :integer
		    indexes :item_av_rating, type: :integer
		    indexes :item_reviews, type: :text
		    indexes :item_location, type: :text
		    indexes :item_sku, type: :text
		    indexes :item_currency_symbol, type: :text
		    indexes :item_image, type: :text
		    indexes :item_seller_name, type: :text
		    indexes :item_url, type: :text
	    end
	end

	def self.search_items(query)
	  self.search(
		query: {
        multi_match: {
          query: query,
          fields: [:item_name, :item_details]
        }
      }
	  	)
	end

	def as_indexed_json(options={})
	  {
	    "item_name" => item_name,
	    "item_details" => item_details,
	    "item_old_price" => item_old_price,
	    "item_new_price" => item_new_price,
	    "item_av_rating" => item_av_rating,
	    "item_reviews" => item_reviews,
	    "item_location" => item_location,
	    "item_sku" => item_sku,
	    "item_currency_symbol" => item_currency_symbol,
	    "item_image" => item_image,
	    "item_seller_name" => item_seller_name,
	    "item_url" => item_url
	  }
	end 


end