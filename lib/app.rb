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
	days_with_special_suffix = {1 => "st", 2 => "nd", 3 => "rd", 31 => "st", 21 => "st", 22 => "nd", 23 => "rd"}
	days_with_special_suffix_array = days_with_special_suffix.keys
	days_with_special_suffix_array.include?(day_of_month) ? days_with_special_suffix[day_of_month] : "th"
end



def date_formatter(date_obj)
	suffix = date_suffix(date_obj)
	date_obj.strftime("Printed on %A, the %d#{suffix} of %b %Y")
end



products_hash = json_reader

date_object = get_date_now

formatted_date = date_formatter(date_object)

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




def print_toy_name(toy_hash, name_key)
	puts "#{toy_hash[name_key]}"
	puts "*********************"

end


def find_retail_price_from_hash(toy_hash, retail_price_key )
	retail_price = toy_hash[retail_price_key].to_f.round(2)
end

def find_total_number_purchases(toy_hash, purchases_key)
	toy_hash[purchases_key].count
end

def calculate_total_sales(toy_hash, purchases_key, price_key )
	total_sales = toy_hash[purchases_key].inject(0) {|sum, value| sum + value[price_key]}
end
def calculate_average_price_per_toy(toy_hash)
	total_sales = calculate_total_sales(toy_hash, "purchases", "price")
	num_purchases = find_total_number_purchases(toy_hash, "purchases")
	total_sales / num_purchases
end

def calculate_average_discount_per_toy_dollars(toy_hash)
	average_price = calculate_average_price_per_toy(toy_hash)
	retail_price = find_retail_price_from_hash(toy_hash, "full-price" )
	(average_price - retail_price).abs
end

def calculate_average_discount_per_toy_percentage(toy_hash)
	average_discount = calculate_average_discount_per_toy_dollars(toy_hash)
	retail_price = find_retail_price_from_hash(toy_hash, "full-price" )
	(average_discount / retail_price * 100).round(2)
end


def per_toy_details(hash_products, items_key)
	hash_products[items_key].each do |item|
		print_toy_name(item, "title")
		puts "Retail Price : #{find_retail_price_from_hash(item, "full-price")}$"
		puts "Total Purchases : #{find_total_number_purchases(item, "purchases")}"
		puts "Total Sales : #{calculate_total_sales(item, "purchases", "price")}$"
		puts "Average Price : #{calculate_average_price_per_toy(item)}$"
		puts "Average Discount in $: #{calculate_average_discount_per_toy_dollars(item)}$"
		puts "Average Discount % : #{calculate_average_discount_per_toy_percentage(item)}%"
		puts
	end
end


per_toy_details(products_hash, "items")


def brands_report_title_printer
		puts " _                         _     "
		puts "| |                       | |    "
		puts "| |__  _ __ __ _ _ __   __| |___ "
		puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
		puts "| |_) | | | (_| | | | | (_| \\__ \\"
		puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
		puts

end

brands_report_title_printer

def generate_products_per_brand_hash(hash_all_products, options = {})
	items_key = options[:items_key] || "items"
	brand_key = options[:brand_key] || "brand"
	products_per_brand = hash_all_products[items_key].group_by {|item| item[brand_key]}
end





# my old methods - decided to go a different as suggested by my last project's reviewer

# def find_unique_brands(hash, main_key, brand_key)
# 	unique_brands = []
# 	hash[main_key].each do |item|
# 		unique_brands.push(item[brand_key]) unless unique_brands.include?(item[brand_key])
# 	end
# 	unique_brands
# end
#
#
#
# def generate_brand_hash(hash, main_key, brand_name, brand_key="brand")
# 	key_brand = {}
#  	key_brand[brand_name] = hash[main_key].select {|item| item[brand_key] == brand_name }
# 	key_brand
# end
#
def print_brand_name(name)
	puts "#{name}"
	puts "*********************"

end

# def find_number_products_per_brand_in_stock(brand_name, brand_hash, options = {})
# 	in_stock = 0
# 	stock_key = options[:stock_key] || "stock"
# 	brand_hash.values.each do |arr|
# 		arr.each do |hash|
# 			in_stock += hash[stock_key]
# 		end
# 	end
# 	in_stock
# end
#
# def find_num_products_per_brand(brand_hash)
# end


# def per_brand_details(hash_all_products, items_key , brand_key)
# 	unique_brands_array = find_unique_brands(hash_all_products, items_key, brand_key)
# 	unique_brands_array.each do |brand|
# 		key_brand_hash = generate_brand_hash(hash_all_products, items_key, brand )
# 		print_brand_name(brand)
# 		puts "Number of Products : #{find_number_products_per_brand_in_stock(brand, key_brand_hash)}"
# 	end
# end
#
# per_brand_details(products_hash, "items", "brand")
def calculate_in_stock_products_per_brand(arr_of_hashes, stock_key = "stock")
	products_per_brand_in_stock = arr_of_hashes.map {|item| item[stock_key]}.reduce(:+)
end

def calculate_average_toy_price_per_brand(arr_of_hashes, options = {})

	price_key = options[:price_key] || "full-price"
	purchases_key = options[:purchases_key] || "purchases"
	total_full_price = arr_of_hashes.map {|item| item[price_key].to_f}.inject(:+)
	total_toys_per_brand = arr_of_hashes.size
	(total_full_price / total_toys_per_brand).round(2)
end

def calculate_total_sales_per_brand(arr_hashes, options = {})
	purchases_key = options[:purchases_key] || "purchases"
	price_key = options[:price_key] || "price"
	total_sales = arr_hashes.map{|item| item[purchases_key].map{|p| p[price_key]}.reduce(:+)}.reduce(:+).round(2)
end

def products_per_brand_details(all_products_hash, options = {})
	products_per_brand = generate_products_per_brand_hash(all_products_hash)
	products_per_brand.each do |key, value|
		print_brand_name(key)
		puts "Number of Products : #{calculate_in_stock_products_per_brand(value)}"
		puts "Average Product Price : #{calculate_average_toy_price_per_brand(value)}$"
		puts "Total Sales : #{calculate_total_sales_per_brand(value)}$"
		puts 
	end
end

products_per_brand_details(products_hash)

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

# def find_unique_brands(hash, main_key, brand_key)
# 	unique_brands = []
# 	hash[main_key].each do |item|
# 		unique_brands.push(item[brand_key]) unless unique_brands.include?(item[brand_key])
# 	end
# 	unique_brands
# end
#
# unique_brands_array = find_unique_brands(products_hash, "items", "brand")
#
# def generate_brand_hash(hash, main_key, unique_array, brand_key)
# 	key_brand = {}
# 	unique_array.each do |brand|
#  		key_brand[brand] = hash[main_key].select {|item| item[brand_key] == brand }
# 	end
# 	key_brand
# end
#
# key_brand_hash = generate_brand_hash(products_hash, "items", unique_brands_array, "brand" )
