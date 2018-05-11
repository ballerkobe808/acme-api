class CreateAssets < ActiveRecord::Migration[5.2]
  def change
    create_table :assets do |t|
      t.string :pair
      t.string :base
      t.string :quote
      t.string :altbase
      t.string :name
      t.string :marketcap

      t.timestamps
    end
  end
end
