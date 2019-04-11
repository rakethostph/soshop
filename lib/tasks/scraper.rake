namespace :scraper do
	desc "Scrape Lazada 100"
	task lazada_100: :environment do

		# require 'user_agent_randomizer'
		require 'open-uri'
		require 'nokogiri'
		require 'csv'
		require 'date'
		require 'progress_bar'

		# Read CSV Files from db/seeds_data/
		CSV.foreach("db/seeds_data/lazada_category_1.csv", headers: true) do |row|
				sleep 1.5
			# Number of times scraper run each page has 40 Items
			max_page = ENV['max_page']
			max_page.to_i.times do |i|

				# Bigin initialize the scraper
				begin

					# User Random User Agent to trick scrape website into thinking thats its new user every time it run the scrape
					# user_agent = UserAgentRandomizer::UserAgent.fetch
					user_agent = UserAgent.fetch
					agent = user_agent.string
					url = row[1]+"/?page=#{i+1}"

					# Parse Url From CSV to nokogiri and also add the user-agent
					page = Nokogiri::HTML(open(url, 'User-Agent' => agent))

					# Find the Json Like format inside Page the pattern is always the third script element
					script = page.search('head script')[2]

					#Remove Unecessary Format in Javascript only reatain the JSON files 
					jsonparse = script.content[/\{\"[a-zA-Z0-9\"\:\-\,\ \=\(\)\.\_\D\/\[\]\}]+/i]

					# Parse The Remaining Json files 
					result = JSON.parse(jsonparse)

					# Create a Empty Array for the progress bar counter
					item_name = []

					# Get the list of names
					result["mods"]["listItems"].each do |result|
						item_name << result["name"]
					end
					
					# Progress bar, it will run each time the url is open
					bar = ProgressBar.new(item_name.count, :bar, :counter, :percentage)

					# Save the JSON data to database
					result["mods"]["listItems"].each do |result|
						@item = Item.new
						@item.item_name 			= result["name"]
						@item.item_details 			= result["description"]
						@item.item_old_price 		= result["originalPrice"]
						@item.item_new_price 		= result["price"]
						@item.item_av_rating 		= result["ratingScore"]
						@item.item_reviews 			= result["review"]+" Reviews"
						@item.item_location 		= result["location"]
						@item.item_sku 				= result["cheapest_sku"]
						@item.item_currency_symbol 	= result["priceShow"][/[Lek؋ƒBr₱$₼lei₽ден]+/i]
						@item.item_image 			= result["image"]
						@item.item_seller_name 		= result["sellerName"]
						@item.item_url 				= "https:"+result["productUrl"]+"/?affiliate_id=229507&affiliate_name=myprezeo"
						@item.save

						sleep 0.1
  						bar.increment!
					end

				# Escape scraper error proceed to next page
				rescue => e
				    puts e
				end
				record = Item.all.count	
				puts record
			end
		end
  	end

  	desc "Scrape Boozy Site"
  	task boozy: :environment do

	# require 'user_agent_randomizer'
	require 'open-uri'
	require 'nokogiri'
	require 'csv'
	require 'date'
	require 'json'
	require 'progress_bar'

		max_page 				= 18
		item_name 				= []
		item_image 				= []
		item_new_price 			= []
		item_currency_symbol 	= []
		item_url 				= []

	max_page.to_i.times do |i|
		date = Date.today.to_time.to_i
		# user_agent = UserAgentRandomizer::UserAgent.fetch
		# user_agent = UserAgent.fetch
		# agent = user_agent.string
		url = "https://boozy.ph/collections/all-products?page=#{i+1}"
		# page = Nokogiri::HTML(open(url, 'User-Agent' => agent))
		page = Nokogiri::HTML(open(url))


		page.css('#shopify-section-collection .title a').each do |item|
		  item_name << item.text.strip

		end

		page.css('#shopify-section-collection img').each do |item|
		  item_image << "https:"+item[:src]
		end
		
		page.css('#shopify-section-collection .money').each do |item|
		  item_new_price << item.text.scan(/[0-9\.]+/i).join()
		end
		page.css('#shopify-section-collection .money').each do |item|
		  item_currency_symbol << item.text[/[Lek؋ƒBr₱$₼lei₽ден]+/i]
		end

		page.css('#shopify-section-collection .title a').each do |item|
		  item_url << "https://boozy.ph"+item[:href]
		end

			
	end

		bar = ProgressBar.new(item_name.count, :bar, :counter, :percentage)
		# Write data to csv files
		# /Users/ruelnopal/Desktop/comsearch/db/seeds_data/
		CSV.open('boozy_products.csv', 'w') do |file|
			file << ["Item Name", "Item Image", "Item Price", "Item Currency", "Item Url"]
			item_name.length.times do |i|
				file << [item_name[i], item_image[i], item_new_price[i], item_currency_symbol[i], item_url[i]]

			sleep 0.1
		  bar.increment!
			end
		end
		begin
			# Write data to database
			item_name.length.times do |i|

				@item = Item.new
				@item.item_name 			= item_name[i]
				@item.item_image 			= item_image[i]
				@item.item_new_price 		= item_new_price[i]
				@item.item_currency_symbol  = item_currency_symbol[i]
				@item.item_url 				= item_url[i]
				@item.affiliate_id 			= 1

				@item.save
				sleep 0.1
			  	bar.increment!
			end
		rescue => e
		    puts e
		end
  	end
end