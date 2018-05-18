require 'open-uri'
require 'rubygems'
require 'nokogiri'

class GetErcDataJob < ApplicationJob
  queue_as :default

  def perform(*args)

    begin

      logger.info "Refreshing ERC20 Data"

      # grab the list of coins online
      doc = Nokogiri::HTML(open("https://www.isiterc20.com",{ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}))   

      # The data is stored in a js variable named currencies. it looks like an angular page and the
      # html is dynamically added as the user scrolls. because of this, we cant scrape the html.
      # But we can get the data we need from the js
      doc.css('script').each do |script|
        if script.content.include? "var currencies ="

          # scrub the data to just the json of the coins and the related data
          json_string = script.content.gsub('var currencies =', '')
          json_string = json_string.gsub('];', ']')
          hash = JSON.parse json_string

          # loop thru the data and grab the erc20 flag
          hash.each do |row|
            # add the coin if it doesnt exist, otherwise update it
            new_coin = Erc20.find_or_initialize_by(symbol: row['code'])
            if (row['erc20'] == nil)
              new_coin.flag = 'No'
            else
              new_coin.flag = 'Yes'
            end
            new_coin.save
          end
        end
        
      end

      

      # grab the list of coins from a file
      # file = File.read("./ERC20.html")
      # doc = Nokogiri::HTML(file)

      # # parse out the html into the list of coins and whether they are erc20 compliant
      # table = doc.css('table')
      # coin_list = table.css('td:first-child').map(&:text)
      # flag_list = table.css('td:last-child').map(&:text)

      # # remove the first row - its not a symbol
      # coin_list.drop(1)
      # flag_list.drop(1)

      # # loop thru and only keep the symbols in parenthesis
      # coin_list.each_with_index do |coin, index|
      #   symbol = ""
      #   coin.sub(/(\(.*?\))/) { symbol = $1 }
      #   symbol = symbol.gsub(/[()]/, "")

      #   # add the coin if it doesnt exist, otherwise update it
      #   new_coin = Erc20.find_or_initialize_by(symbol: symbol)
      #   new_coin.flag = flag_list[index]
      #   new_coin.save
      # end
      
    rescue => exception
      puts exception
      
    end
    

  end
end
