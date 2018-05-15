class CreateErc20s < ActiveRecord::Migration[5.2]
  def change
    create_table :erc20s do |t|
      t.string :symbol
      t.string :flag

      t.timestamps
    end
  end
end
