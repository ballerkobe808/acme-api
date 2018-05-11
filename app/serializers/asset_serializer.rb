# adding this serializer to only return the data we absolutely need back to the client. 
# originally we were returning too big a file because of all the extra updated_at, created_at,
# and data that wasnt essential. trimming down the data chunk to the bare minimum
class AssetSerializer < ActiveModel::Serializer
  attributes :name, :altbase, :marketcap

  # cool thing about Active model serializer is the ability to add child tables with one
  # line. Also defining the child serializer here will take precedence over the serializer
  # of the same name defined in its own file
  has_many :asks
  class AskSerializer < ActiveModel::Serializer
    attributes :price, :volume, :timestamp
  end

  has_many :bids
  class BidSerializer < ActiveModel::Serializer
    attributes :price, :volume, :timestamp
  end

  has_many :spreads
  class SpreadSerializer < ActiveModel::Serializer
    attributes :time, :bid, :ask
  end

  has_many :trades
  class TradeSerializer < ActiveModel::Serializer
    attributes :price, :volume, :time
  end
  
end
