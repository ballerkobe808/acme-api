class CreateBids < ActiveRecord::Migration[5.2]
  def change
    create_table :bids do |t|
      t.references :asset, foreign_key: true
      t.string :price
      t.string :volume
      t.string :timestamp

      t.timestamps
    end
  end
end
