# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_05_14_080249) do

  create_table "asks", force: :cascade do |t|
    t.integer "asset_id"
    t.string "price"
    t.string "volume"
    t.string "timestamp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_id"], name: "index_asks_on_asset_id"
  end

  create_table "assets", force: :cascade do |t|
    t.string "pair"
    t.string "base"
    t.string "quote"
    t.string "altbase"
    t.string "name"
    t.string "marketcap"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "day_low"
    t.string "day_high"
    t.string "last_traded"
    t.string "opening_price"
    t.string "display_decimals"
  end

  create_table "bids", force: :cascade do |t|
    t.integer "asset_id"
    t.string "price"
    t.string "volume"
    t.string "timestamp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_id"], name: "index_bids_on_asset_id"
  end

  create_table "spreads", force: :cascade do |t|
    t.integer "asset_id"
    t.string "time"
    t.string "bid"
    t.string "ask"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_id"], name: "index_spreads_on_asset_id"
  end

  create_table "trades", force: :cascade do |t|
    t.integer "asset_id"
    t.string "price"
    t.string "volume"
    t.string "time"
    t.string "buysell"
    t.string "marketlimit"
    t.string "misc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_id"], name: "index_trades_on_asset_id"
  end

end
