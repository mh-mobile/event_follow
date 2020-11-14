# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_11_14_040037) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.bigint "site_id", null: false
    t.integer "site_event_id", null: false
    t.string "title", null: false
    t.datetime "started_at", null: false
    t.datetime "ended_at", null: false
    t.string "banner", null: false
    t.string "url", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["site_id", "site_event_id"], name: "index_events_on_site_and_site_event_id", unique: true
    t.index ["site_id"], name: "index_events_on_site_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.bigint "follower_id", null: false
    t.bigint "followed_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["followed_id"], name: "index_friendships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_friendships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_friendships_on_follower_id"
  end

  create_table "sites", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_tokens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "access_token", null: false
    t.string "access_token_secret", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_tokens_on_user_id"
  end

  create_table "users", id: :bigint, default: nil, force: :cascade do |t|
    t.string "screen_name", null: false
    t.string "name", null: false
    t.string "profile_image", null: false
  end

  add_foreign_key "events", "sites"
  add_foreign_key "friendships", "users", column: "followed_id"
  add_foreign_key "friendships", "users", column: "follower_id"
  add_foreign_key "user_tokens", "users"
end
