class AddErc20ToAssets < ActiveRecord::Migration[5.2]
  def change
    add_column :assets, :erc20, :string
  end
end
