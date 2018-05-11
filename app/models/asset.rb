class Asset < ApplicationRecord
  has_many :asks, :dependent => :destroy
  has_many :bids, :dependent => :destroy
  has_many :spreads, :dependent => :destroy
  has_many :trades, :dependent => :destroy
end
