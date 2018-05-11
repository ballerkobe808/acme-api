class CreateSpreads < ActiveRecord::Migration[5.2]
  def change
    create_table :spreads do |t|
      t.references :asset, foreign_key: true
      t.string :time
      t.string :bid
      t.string :ask

      t.timestamps
    end
  end
end
