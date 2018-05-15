require 'open-uri'
require 'rubygems'
require 'nokogiri'

class GetErcDataJob < ApplicationJob
  queue_as :default

  def perform(*args)

    begin

      # grab the list of coins online
      file = File.read("./ERC20.html")
      doc = Nokogiri::HTML(file)
      # doc = Nokogiri::HTML(open("https://www.isiterc20.com/"))   

      # parse out the html into the list of coins and whether they are erc20 compliant
      table = doc.css('table')
      coin_list = table.css('td:first-child').map(&:text)
      flag_list = table.css('td:last-child').map(&:text)

      # remove the first row - its not a symbol
      coin_list.drop(1)
      flag_list.drop(1)

      # loop thru and only keep the symbols in parenthesis
      coin_list.each_with_index do |coin, index|
        symbol = ""
        coin.sub(/(\(.*?\))/) { symbol = $1 }
        symbol = symbol.gsub(/[()]/, "")

        # add the coin if it doesnt exist, otherwise update it
        new_coin = Erc20.find_or_initialize_by(symbol: symbol)
        new_coin.flag = flag_list[index]
        new_coin.save
      end
      
    rescue => exception
      puts exception
      
    end
    

  end
end
