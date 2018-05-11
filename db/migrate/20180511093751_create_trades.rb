class CreateTrades < ActiveRecord::Migration[5.2]
  def change
    create_table :trades do |t|
      t.references :asset, foreign_key: true
      t.string :price
      t.string :volume
      t.string :time
      t.string :buysell
      t.string :marketlimit
      t.string :misc

      t.timestamps
    end
  end
end
