class AddDayLowDayHighLastTradedOpeningPriceToAssets < ActiveRecord::Migration[5.2]
  def change
    add_column :assets, :day_low, :string
    add_column :assets, :day_high, :string
    add_column :assets, :last_traded, :string
    add_column :assets, :opening_price, :string
  end
end
