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

		max_page 				= 21
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

  	desc "Scrape Boozy Site"
  	task seed_boozy: :environment do
		require 'csv'
		CSV.foreach('boozy_products.csv', headers: true) do |row|
			Item.create(
			    item_name: row[0],
			    item_image: row[1],
			    item_new_price: row[2],
			    item_currency_symbol: row[3],
			    item_url: row[4]
			    
			)
			puts "Post: " + "#{$.}".to_s
		end
  	end

  	desc "shopee_cat"
  	task shopee_cat: :environment do
		require 'csv'
		CSV.foreach('shopee_main.csv', headers: true) do |row|
			Category.create(
			    category_name: row[0],
			    category_url: row[1],
			)
			puts "Post: " + "#{$.}".to_s
		end
  	end

  	desc "shopee_cat"
  	task shopee_sub_cat: :environment do
		require "selenium-webdriver"
		driver = Selenium::WebDriver.for :chrome
		@cat = Category.all

		@cat.each do |link|
			url = link.category_url
			driver.navigate.to "#{url}"
			wait = Selenium::WebDriver::Wait.new(:timeout => 200)
			driver.switch_to.active_element
			sleep 5

			category_urls = wait.until {
			  element = driver.find_elements(:css, ".full-brand-list-item__brand-cover-image")
			}
			category_url = []
			category_urls.each do |line|
				category_url << line.attribute("href")
				
			end

			category_names = wait.until {
			  element = driver.find_elements(:css, ".full-brand-list-item__brand-name")
			}
			category_name = []
			category_names.each do |line|
				category_name << line.text
				
			end

			category_name.length.times do |i|
				SubCategory.create(
					category_id: link.id,
			    	subcategory_name: category_name[i],
			    	sub_category_url: category_url[i]
				)
			end

			puts category_name.size

			sleep 5

		end
		sleep 5
  	end

  	desc "shopee_product"
  	task shopee_product: :environment do
		require "selenium-webdriver"
		require "csv"

		driver = Selenium::WebDriver.for :chrome
		@cat = SubCategory.all

		# t.string "subcategory_name"
    	#t.string "sub_category_url"
    	#shopee-item-card__text-name
		@cat.each do |link|
			url = link.sub_category_url
			driver.navigate.to "#{url}"
			wait = Selenium::WebDriver::Wait.new(:timeout => 200)
			driver.switch_to.active_element
			sleep 5
			begin

				page_total = wait.until {
				  element = driver.find_element(:css, ".shopee-mini-page-controller__total")
				}

				max_page = page_total.text.to_i

				# puts max_page

				# item_name = []
				item_url = []
			
				max_page.times.each do |i|
					page  = driver.navigate.to "#{url}?page=#{i+0}&sortBy=pop"
					wait = Selenium::WebDriver::Wait.new(:timeout => 20)
					driver.switch_to.active_element

					sleep 5
					driver.execute_script("window.scrollTo(0, document.body.scrollHeight)")
					sleep 2

					category_urls = wait.until {
					  element = driver.find_elements(:xpath, "//div[contains(@class,'shop-search-result-view__item')]/div/a")
					}

					category_urls.each do |line|
						item_url << line.attribute("href")
					end

					# item_url.length.times do |i|

					# 	item = Item.new
					# 	item.item_url = item_url[i]
					# 	item.save
					# puts item_url[i]
					# end

					CSV.open('db/shopee_items_urls.csv', 'a+') do |file|
						# file << ["Item Url"]
						item_url.length.times do |i|
							file << [item_url[i]]
							puts item_url[i]
						end
					end


					

					# puts category_name.size

					sleep 2
				end
				# item_url.length.times do |i|
				# 	item = Item.new
				# 	item.item_url = item_url[i]
				# 	item.save
	
				# puts item_url[i]
				# end
				# sleep 1

				

			rescue Exception => e
				puts e
			end
			
			
		end
		sleep 5
  	end
  	desc "shopee_product"
  	task update_sub_category: :environment do
  		require "selenium-webdriver"
		require "csv"
		begin

		driver = Selenium::WebDriver.for :chrome
		@cat = SubCategory.where(product_total: nil)

		

			@cat.each do |link|
				url = link.sub_category_url
				driver.navigate.to "#{url}"
				wait = Selenium::WebDriver::Wait.new(:timeout => 20)
				driver.switch_to.active_element
				sleep 2

				product_total = wait.until {
					  element = driver.find_element(:css, ".section-seller-overview__item-text-value")
				}

				total =  product_total.text.to_i

				link.update_attribute(:product_total, total)

				puts total
			end

		rescue Exception => e
				puts e
		end

  		
  	end

	desc "shopee_product"
	task item_url_create: :environment do
		require 'csv'
		CSV.foreach('db/shopee_items_url.csv', headers: true) do |row|
			Item.create(
			    item_url: row[0],
			)

			puts "Item: " + "#{$.}".to_s
		end
	end

	desc "shopee_product"
	task update_items: :environment do
		require 'csv'
		require "selenium-webdriver"
		driver = Selenium::WebDriver.for :chrome
		wait = Selenium::WebDriver::Wait.new(:timeout => 20)

		@items = Item.where(item_name: nil)
		@items.each do |item|
			
			begin
			
				url = item.item_url
				driver.navigate.to "#{url}"

				item_name = wait.until {
					  element = driver.find_element(:css, ".qaNIZv")
				}


				# rating = wait.until {
				# 	  element = driver.find_element(:css, "._2z6cUg")
				# }

				# review = wait.until {
				# 	  element = driver.find_element(:xpath, "//div[contains(@class,'flex')]/div")
				# }

				# regular_price = wait.until {
				# 	  element = driver.find_element(:css, "._3_ISdg")
				# }
				# sales_price = wait.until {
				# 	  element = driver.find_element(:css, "._3n5NQx")
				# }

				# total_sold = wait.until {
				# 	  element = driver.find_element(:css, "._22sp0A")
				# }

				# brand = wait.until {
				# 	  element = driver.find_element(:css, "._2H-513")
				# }

				# # ship_from = wait.until {
				# # 	  element = driver.find_element(:xpath, "//div[contains(@class,'_1ymsZN')]/div")
				# # }
				# description = wait.until {
				# 	  element = driver.find_element(:css, "._2u0jt9")
				# }
				puts single_item = item_name.text

				item.update_column :item_name, single_item
				# item.update_attribute(:item_details, description.text)
				# item.update_attribute(:item_old_price, regular_price.text.delete('₱ ,'))
				# item.update_attribute(:item_new_price, sales_price.text.delete('₱ ,'))
				# item.update_attribute(:item_av_rating, rating.text)
				# item.update_attribute(:item_seller_name, brand.text)
				
			rescue Exception => e
				puts e
			end
			
		end
		
	end

end