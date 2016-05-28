require 'json'
#add date class
require 'date'
# require 'artii'

def write_to_file(line, file_name = "../report.txt")
	open(file_name, 'a') { |f|
  f << "#{line}\n"
}
end

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

def sales_report_title_printer
	write_to_file "                                                        "
	write_to_file "	_____       _            _____                       _"
	write_to_file "/ ____|     | |          |  __ \                     | |"
  write_to_file "| (___   __ _| | ___ ___  | |__) |___ _ __   ___  _ __| |_"
  write_to_file "\___ \ / _` | |/ _ \ __| |  _  // _ \ '_ \ / _ \| '__| __|"
	write_to_file "____) | (_| | |  __\__ \ | | \ \  __/ |_) | (_) | |  | |_"
	write_to_file "|_____/ \__,_|_|\___|___/ |_|  \_\___| .__/ \___/|_|   \__|"
	write_to_file "																	 | |                     "
	write_to_file "																	 |_|                     "
	write_to_file ""
  write_to_file ("*"*100)
end

def products_report_title_printer
	write_to_file "                     _            _       "
	write_to_file "                    | |          | |      "
	write_to_file " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
	write_to_file "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
	write_to_file "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
	write_to_file "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
	write_to_file "| |                                       "
	write_to_file "|_|                                       "
	write_to_file ""
end




def print_toy_name(toy_hash, name_key)
	write_to_file "#{toy_hash[name_key]}"
	write_to_file "*********************"

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
		write_to_file "Retail Price : #{find_retail_price_from_hash(item, "full-price")}$"
		write_to_file "Total Purchases : #{find_total_number_purchases(item, "purchases")}"
		write_to_file "Total Sales : #{calculate_total_sales(item, "purchases", "price")}$"
		write_to_file "Average Price : #{calculate_average_price_per_toy(item)}$"
		write_to_file "Average Discount in $: #{calculate_average_discount_per_toy_dollars(item)}$"
		write_to_file "Average Discount % : #{calculate_average_discount_per_toy_percentage(item)}%"
		write_to_file ""
	end
end



def brands_report_title_printer
		write_to_file " _                         _     "
		write_to_file "| |                       | |    "
		write_to_file "| |__  _ __ __ _ _ __   __| |___ "
		write_to_file "| '_ \\| '__/ _` | '_ \\ / _` / __|"
		write_to_file "| |_) | | | (_| | | | | (_| \\__ \\"
		write_to_file "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
		write_to_file ""

end



def generate_products_per_brand_hash(hash_all_products, options = {})
	items_key = options[:items_key] || "items"
	brand_key = options[:brand_key] || "brand"
	products_per_brand = hash_all_products[items_key].group_by {|item| item[brand_key]}
end




def print_brand_name(name)
	write_to_file "#{name}"
	write_to_file "*********************"

end


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
		write_to_file "Number of Products : #{calculate_in_stock_products_per_brand(value)}"
		write_to_file "Average Product Price : #{calculate_average_toy_price_per_brand(value)}$"
		write_to_file "Total Sales : #{calculate_total_sales_per_brand(value)}$"
		write_to_file ""
	end
end


def start
	products_hash = json_reader

	date_object = get_date_now

	formatted_date = date_formatter(date_object)

	write_to_file ""
	write_to_file "#{formatted_date}"
	sales_report_title_printer
	products_report_title_printer
	per_toy_details(products_hash, "items")
	brands_report_title_printer
	products_per_brand_details(products_hash)

end


start
