require 'nokogiri'
require 'open-uri'
require 'sqlite3'
require 'sequel'

# Global variables
# $EmpikURL = 'https://www.empik.com/sport/sprzet-fitness/bieznie,41170101,s'

DB = Sequel.sqlite('products.db')

DB.create_table?(:products) do
    primary_key :id
    String :title
    String :price
    String :category
    String :url
    String :description
  end

class Product < Sequel::Model(DB[:products])
end  


def scrape_and_save(url)
    doc = Nokogiri::HTML(URI.open(url))
  
    # Extraction of products only works on empik site
    doc.css('div.product-details-wrapper.ta-details-box').each_with_index  do |product, index|
        product_id = product['data-shop-id']
        title = product.css('strong.ta-product-title').text
        price = product.css('[itemprop="price"]').attr('content')
        category = product.css('span.productMainInfoSuffix.ta-product-category').text.strip
        product_url = product.css('a.seoTitle').map { |a| a['href'] }
        product_url = URI.join(url, product_url.join(""))

        # ----- Getting data about product from subpage ----- #
        subproduct_doc = Nokogiri::HTML(URI.open(product_url))
        description = subproduct_doc.css('section#DetailedData')
      
       
        # puts ""
        # puts "Product id: #{product_id}"
        # puts "Title: #{title}"
        # puts "Price: #{price}"
        # puts "Category: #{category}"
        # puts "Link: #{product_url}"
        # puts "Product Data: #{description}:"
        Product.create(title: title, price: price, category: category, url: product_url, description: description)
       end 
  end


  def crawl_by_keywords(keywords)
    scrape_and_save("https://www.empik.com/szukaj/produkt?q=#{keywords}&qtype=basicForm")
  end

crawl_by_keywords("plecak")

Product.all.each do |product|
  puts ""
  puts "[#{product.id}] Title: #{product.title}" 
  puts "Price: $#{product.price}"
  puts "Category: $#{product.category}"
  puts "URL: #{product.url}"
  puts "Description: #{product.description}"
end

puts ""
puts ""
puts "Total Products Found: #{Product.count}"