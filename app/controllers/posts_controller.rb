require 'rest-client'
require 'json'

class PostsController < ApplicationController
  def index
    puts 'testing log'
    # @posts = Post.all
    

    # response = RestClient.get 'https://api.kraken.com/0/public/Assets'
    ticker_response = RestClient.get 'https://api.coinmarketcap.com/v1/ticker'
    ticker_json = JSON.parse(ticker_response)
    # ticker_keys = ticker_json.keys

   

    assets_response = RestClient.get 'https://api.kraken.com/0/public/Assets'
    assets_json = JSON.parse(assets_response)['result']
    assets_keys = assets_json.keys



    asset_pairs_response = RestClient.get 'https://api.kraken.com/0/public/AssetPairs'
    asset_pairs_json = JSON.parse(asset_pairs_response)['result']
    asset_pairs_keys = asset_pairs_json.keys

    # asset_pairs = []
    asset_pairs_keys.each do |key|
      asset = {"pair" => key, "base" => asset_pairs_json[key]['base'], "quote" => asset_pairs_json[key]['quote']}

      
      # using this quote check to say it is a USD pair
      # could alse use a string parse of the last 3 chars and
      # see if it matches USD...
      # ALSO ignore the .d pairs - WHAT ARE THESE???
      # they seem to be same as an existing pair without a .d at the end...
      if (asset['pair'].exclude? ".d") && (asset['quote'] == "ZUSD") && (asset['pair'].exclude? "X")

        # add the alternative name of the base using the asset listing we got
        # matching the asset pair to the asset using the asset key which is the name
        assets_keys.each do |key|
          if asset['base'] == key
            asset['altbase'] = assets_json[key]['altname']
          end
        end

        # special case for bitcoin - kraken uses xbt, but everywhere else uses btc, 
        # so set that here
        if (asset['altbase'] == 'XBT') 
          asset['altbase'] = 'BTC'
        end

        

        # lookup the full name of the coin using the list from the ticker - 
        # matching based on the altBaseName (since kraken uses its own symbols...)
        ticker_json.each do |ticker|
          if ticker['symbol'] == asset['altbase']
            asset['name'] = ticker['name']
            asset['marketcap'] = ticker['market_cap_usd']
          end
        end

        # save the asset to the db
        asset_db = Asset.new(pair: key, base: asset['base'], quote: asset['quote'], altbase: asset['altbase'], name: asset['name'], marketcap: asset['marketcap'])

        # ok now look up each coin individually and grab the data from kraken
        puts '--timer--'
        # we have to wait a certain number of seconds before making calls to kraken or we will exceed our
        # limits and get locked out - if we make one call every 3 seconds we should never exceed the limit
        # https://www.kraken.com/help/api#api-call-rate-limit
        sleep(3)

        depth_url = 'https://api.kraken.com/0/public/Depth?pair=' + key
        depth_response = RestClient.get depth_url
        depth_json = JSON.parse(depth_response)['result'][key]

        depth_json['asks'].each do |depth|
          asset_db.asks.build(price: depth[0], volume: depth[1], timestamp: depth[2])
        end

        depth_json['bids'].each do |depth|
          asset_db.bids.build(price: depth[0], volume: depth[1], timestamp: depth[2])
        end
        

        

        sleep(3)

        spread_url = 'https://api.kraken.com/0/public/Spread?pair=' + key
        spread_response = RestClient.get spread_url
        spread_json = JSON.parse(spread_response)['result'][key]

        spread_json.each do |spread|
          asset_db.spreads.build(time: spread[0], bid: spread[1], ask: spread[2])
        end

        sleep(3)

        trade_url = 'https://api.kraken.com/0/public/Trades?pair=' + key
        trade_response = RestClient.get trade_url
        trade_json = JSON.parse(trade_response)['result'][key]


        trade_json.each do |trade|
          asset_db.trades.build(price: trade[0], volume: trade[1], time: trade[2], buysell: trade[3], marketlimit: trade[4], misc: trade[5])
        end


        # wrap the delete and insert in a transaction so that there is no lag in case there is
        # a request to pull the data in the middle of a delete and insert
        # we are replacing the existing asset pair with the newly fetched/created one
        Asset.transaction do
          Asset.where(pair: key).destroy_all
          asset_db.save
        end

      end
    end


    # puts asset_pairs
    # puts ticker_json

    # @posts = asset_pairs
    @posts = Asset.all

    render json: @posts
  end

end