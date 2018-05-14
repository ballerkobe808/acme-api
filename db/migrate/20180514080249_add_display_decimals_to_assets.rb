class AddDisplayDecimalsToAssets < ActiveRecord::Migration[5.2]
  def change
    add_column :assets, :display_decimals, :string
  end
end
