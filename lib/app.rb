require 'json'
#add date class
require 'date'


def json_reader
	path = File.join(File.dirname(__FILE__), '../data/products.json')
	file = File.read(path)
	JSON.parse(file)
end


def get_date_now
	DateTime.now.to_date
end


def date_suffix(date_obj)
	day_of_month = date_obj.day
	days_with_special_suffix = {1 => "st", 2 => "nd", 3 => "rd", 31 => "st"}
	days_with_special_suffix_array = days_with_special_suffix.keys
	days_with_special_suffix_array.include?(day_of_month) ? days_with_special_suffix[day_of_month] : "th"
end



def date_formatter(date_obj)
	suffix = date_suffix(date_obj)
	date_obj.strftime("Printed on %A, the %d#{suffix} of %b %Y")
end



products_hash = json_reader


# Print today's date
# creating a date time object and converting it to a date object in my local time zone

date_object = get_date_now



formatted_date = date_formatter(date_object)

# #Creating a hash to store days of month with special suffix
# days_with_special_suffix = {1 => "st", 2 => "nd", 3 => "rd", 31 => "st"}
#
# #pulling all the keys as an array
# days_with_special_suffix_array = days_with_special_suffix.keys
#
# #extracting day of month from the date
# day_of_month = date_object.day
#
# #ternary operation to determine the correct suffix for a give day of month
# suffix = days_with_special_suffix_array.include?(day_of_month) ? days_with_special_suffix[day_of_month] : "th"

#using strftime method to format the date in the following format ex - Sunday, 14th of Apr 2016
puts ""
puts formatted_date

def products_report_title_printer
	puts "                     _            _       "
	puts "                    | |          | |      "
	puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
	puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
	puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
	puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
	puts "| |                                       "
	puts "|_|                                       "
	puts ""
end

products_report_title_printer

def toys_hash_details

end

def find_unique_brands(hash, main_key, brand_key)
	unique_brands = []
	hash[main_key].each do |item|
		unique_brands.push(item[brand_key]) unless unique_brands.include?(item[brand_key])
	end
	unique_brands
end

unique_brands_array = find_unique_brands(products_hash, "items", "brand")

def generate_brand_hash(hash, main_key, unique_array, brand_key)
	key_brand = {}
	unique_array.each do |brand|
 		key_brand[brand] = hash[main_key].select {|item| item[brand_key] == brand }
	end
	key_brand
end

key_brand_hash = generate_brand_hash(products_hash, "items", unique_brands_array, "brand" )


def per_brand_toys_details
end


def print_brand_name(brand_name)
	puts "Brand Name: #{brand_name}"
end

def find_toys_in_stock(hash, stock_key)
	in_stock = 0
	hash.values.each do |value_arr|
		value_arr.each do |hash_product|
			in_stock += hash_product[stock_key]
	end
end



#
#
# # For each product in the data set:
#   # Print the name of the toy
# 	def retail_price_from_hash(hash, main_hash_key, retail_price_key )
# 		retail_price = 0
# 		hash[main_hash_key].each do |item|
# 			retail_price = item[retail_price_key].to_f
# 		end
# 		retail_price
# 	end
#
# 		total_actual_sales = 0
# 		retail_price = retail_price_from_hash(products_hash, "items", "full-price")
# 		#puts "Toy : #{item["title"]}"
# 		puts "Retail Price: #{retail_price}$"
# 		#num_of_purchases = item["purchases"].count
# 		#total_expected_sales = (num_of_purchases * retail_price)
# 		#puts "Total Number of Purchases : #{num_of_purchases}"
# 		# item["purchases"].each do |purchase|
# 		# 	total_actual_sales += purchase["price"]
# 		# end
# 		# Used Inject as per the reviewer's suggestion - Thanks
# 		# total_actual_sales = item["purchases"].inject(0) {|sum, value| sum + value["price"]}
# 		# puts "Total Amount of Sales = #{total_actual_sales}$"
# 		# average_price_toy = total_actual_sales /num_of_purchases
# 		# puts "Average Price of Toy : #{average_price_toy}$"
# 		# average_discount = (average_price_toy  - retail_price).abs
# 		# puts "Average Discount in $: #{average_discount}$"
# 		# puts "Average Discount % : #{(average_discount / retail_price * 100).round(2)}%"
# 		# puts ""
# 		# puts "-----------------------------------------------------------------------------"
# 		# puts ""
#
#
#
#   # Print the retail price of the toy
#
#   # Calculate and print the total number of purchases
#   # Calculate and print the total amount of sales
#   # Calculate and print the average price the toy sold for
#   # Calculate and print the average discount (% or $) based off the average sales price
#
#
#
#
#
# 	puts " _                         _     "
# 	puts "| |                       | |    "
# 	puts "| |__  _ __ __ _ _ __   __| |___ "
# 	puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
# 	puts "| |_) | | | (_| | | | | (_| \\__ \\"
# 	puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
# 	puts
#
# # For each brand in the data set:
#   # Print the name of the brand
#   # Count and print the number of the brand's toys we stock
#   # Calculate and print the average price of the brand's toys
#   # Calculate and print the total revenue of all the brand's toy sales combined
#
# # create a unique brands array to group all Toys for each brand
# def unique_brands(hash_brands, key_main_hash, key_sec_hash)
# 	unique_brands = []
# 	hash_brands[key_main_hash].each do |item|
# 		unique_brands.push(item[key_sec_hash]) unless unique_brands.include?(item[key_sec_hash])
# 		end
# 	unique_brands
# end
#
# uniq_brands = unique_brands(products_hash, "items", "brand")
#
# uniq_brands.each do |brand|
#
# 	key_brand = {}
# 	#loop through each brand and populate the key_brand hash with all toys grouped in an array for a specific brand -> key
#  	key_brand[brand] = products_hash["items"].select {|item| item["brand"] == brand }
#
# 	#initialize variables to be used to keep track of purchases and in stock numbers
#   in_stock = 0
# 	purchases_arr = []
# 	full_price_per_brand = 0
# 	#loop through the values array of the hash
# 	num_products_per_brand = 0
# 	key_brand.values.each do |v|
# 		num_products_per_brand = v.count
# 		#foreach hash in the array
# 		v.each do |a|
# 			in_stock += a["stock"]
# 			purchases_arr.push(a["purchases"])
# 			full_price_per_brand += a["full-price"].to_f
# 		end
# 	end
# 	total_sales = 0
# 	total_number_toys_sold = 0
# 	purchases_arr.each do |a|
# 		a.each do |hash|
# 			total_sales += hash["price"]
# 			total_number_toys_sold += 1
# 		end
# 	end
# 	puts ""
# 	puts "Brand Name: #{brand}"
# 	puts "#{brand}'s Toys In Stock : #{in_stock} "
# 	puts "#{brand}'s Average Toy Price : #{(full_price_per_brand / num_products_per_brand).round(2)}$ "
# 	puts "#{brand}'s Total Sales : #{total_sales.round(2)}$ "
# 	puts "------------------------------------------------------------------------------------"
# 	puts ""
# end
