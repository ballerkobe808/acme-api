class RefreshCoinsJob < ApplicationJob
  queue_as :default

  # infinite loop to keep calling the same job over and over
  after_perform :rerun

  # rerun the same job, but wait a tiny bit to take a rest lol
  def rerun
    sleep(1.minute)
    RefreshCoinsJob.perform_now
  end

  # the big job to do here, is to grab the data of coins we are interested in from kraken, 
  # visit the api at kraken and get all the related information we are interested in 
  # (without taking down the kraken server or exceeding our limit to how much we can it it)
  # and also grabbing related data from any other external resource, and then save it all
  # into our local db for quick retrieval by our own api
  def perform(*args)

    begin
      logger.info "************ STARTING refresh coins ******************************************"

      # # grab the main assets from kraken
      assets_json = get_coin_data('https://api.kraken.com/0/public/Assets', '')
      assets_keys = assets_json.keys


      # grab the asset pairs from kraken
      asset_pairs_json = get_coin_data('https://api.kraken.com/0/public/AssetPairs', '')
      asset_pairs_keys = asset_pairs_json.keys

      # grab the market cap and full name from a different source
      market_response = RestClient.get 'https://api.coinmarketcap.com/v1/ticker'
      market_json = JSON.parse(market_response)


      # loop thru the asset pairs that kraken gives us
      asset_pairs_keys.each do |key|

        # wrap every coin in a try catch - if it fails go to the next coin
        begin

          asset = {"pair" => key, "base" => asset_pairs_json[key]['base'], 
            "quote" => asset_pairs_json[key]['quote']}

          # we only want pairs with a USD currency
          # using "quote" of ZUSD check to say it is a USD pair - is this a valid check??
          # could alse use a string parse of the last 3 chars and
          # see if it matches USD...
          # ALSO ignore the .d pairs - WHAT ARE THESE???
          # they seem to be duplicates of an existing pair without a .d at the end...
          if (asset['pair'].exclude? ".d") && (asset['quote'] == "ZUSD") 
            # && (asset['pair'].exclude? "X") #this line is for testing to cut down on our results

            # add the alternative name of the base using the asset listing we got
            # matching the asset pair to the asset using the asset key which is the name
            assets_keys.each do |key|
              if asset['base'] == key
                asset['altbase'] = assets_json[key]['altname']
                asset['display_decimals'] = assets_json[key]['display_decimals']
              end
            end

            # special case for bitcoin - kraken uses xbt, but everywhere else uses btc, 
            # so set that here
            if (asset['altbase'] == 'XBT') 
              asset['altbase'] = 'BTC'
            end

            # look up the assets compliance in the erc20 table
            erc20 = Erc20.where(symbol: asset['altbase']).first
            if (erc20)
              asset['erc20'] = erc20['flag']
            else
              asset['erc20'] = 'no data'  
            end

            # lookup the full name of the coin using the list from the ticker - 
            # matching based on the altBaseName (since kraken uses its own symbols...)
            market_json.each do |market|
              if market['symbol'] == asset['altbase']
                asset['name'] = market['name']
                asset['marketcap'] = market['market_cap_usd']
              end
            end


            # save the asset to the db model
            asset_db = Asset.new(pair: key, base: asset['base'], quote: asset['quote'], 
            altbase: asset['altbase'], name: asset['name'], marketcap: asset['marketcap'],
            # day_low: ticker_json['l'][0], day_high: ticker_json['h'][0], last_traded: ticker_json['c'][0],
            # opening_price: ticker_json['o'], 
            display_decimals: asset['display_decimals'],
            erc20: asset['erc20'])


             # ok now look up each coin individually and grab the data from kraken
             logger.info '--pulling coin data from kraken -- (' + key + ')' 

            # grab additional data from kraken
            ticker_json = get_coin_data('https://api.kraken.com/0/public/Ticker?pair=' + key, key)

            if (ticker_json != nil)
              asset_db['last_traded'] = ticker_json['c'][0]
            end
            # # save the asset to the db model
            # asset_db = Asset.new(pair: key, base: asset['base'], quote: asset['quote'], 
            #   altbase: asset['altbase'], name: asset['name'], marketcap: asset['marketcap'],
            #   day_low: ticker_json['l'][0], day_high: ticker_json['h'][0], last_traded: ticker_json['c'][0],
            #   opening_price: ticker_json['o'], display_decimals: asset['display_decimals'],
            #   erc20: asset['erc20'])
           
            # grab the asks and bids info for this coin and add to the coin in the db
            depth_json = get_coin_data('https://api.kraken.com/0/public/Depth?pair=' + key, key)

            if (depth_json != nil)
              depth_json['asks'].each do |depth|
                asset_db.asks.build(price: depth[0], volume: depth[1], timestamp: depth[2])
              end
            end

            if (depth_json != nil)
              depth_json['bids'].each do |depth|
                asset_db.bids.build(price: depth[0], volume: depth[1], timestamp: depth[2])
              end
            end

            # begin
            # grab the spread info for this coin and add/replace it in the db
            spread_json = get_coin_data('https://api.kraken.com/0/public/Spread?pair=' + key, key)

            if (spread_json != nil)
              spread_json.each do |spread|
                asset_db.spreads.build(time: spread[0], bid: spread[1], ask: spread[2])
              end
            end

            # begin
            # grab the trade info for this coin and add/replace it in the db
            trade_json = get_coin_data('https://api.kraken.com/0/public/Trades?pair=' + key, key)

            if (trade_json != nil)
              trade_json.each do |trade|
                asset_db.trades.build(price: trade[0], volume: trade[1], time: trade[2], buysell: trade[3], 
                  marketlimit: trade[4], misc: trade[5])
              end
            end

            # wrap the delete and insert in a transaction so that there is no lag in case there is
            # a request to pull the data in the middle of a delete and insert
            # we are replacing the existing asset pair with the newly fetched/created one
            Asset.transaction do
              # first remove the coin (and child data) from the data before we insert our newly aquired coin info
              Asset.where(pair: key).destroy_all
              asset_db.save
            end

          end

          # if there is any issue when getting a coins data - usually the response errored or is null
          # then just move on to the next coin
        rescue => error
          logger.error 'SINGLE coin refresh error-----------: ' + key
          logger.error error
          next
        end
      end

      logger.info "*********** FINISHED refresh coins ******************************************"

    # if there is an error grabbing the coin list, then just restart the job  
    rescue => error
      logger.error "GENERAL coin list refresh error: -------------" 
      logger.error error
      rerun
    end

  end


  # get the json from the url - we are assuming the kraken api, and the data
  # back in a specific format
  def get_coin_data(url, key)
    begin
      response = RestClient.get url
      json_response = JSON.parse(response)
      if (!json_response['result'])
        logger.error 'ERROR OBJECT AT ' + url
        logger.error json_response['error'][0]
        return nil
      elsif (key != '') 
        return json_response['result'][key]
      else
        # otherwise return w/o looking for a key
        return json_response['result']
      end

    rescue => error
      # if there was an http error, then show it - however return an empty array, so there is something there
      logger.error 'error retrieving url ------------------ ' + url
      logger.error error
      return nil
    end
  end

end
