# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_06_04_064754) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "crawl_tweets", id: :string, force: :cascade do |t|
    t.text "text", null: false
    t.datetime "tweeted_at", null: false
    t.string "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "event_url", null: false
    t.index ["user_id"], name: "index_crawl_tweets_on_user_id"
  end

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
    t.string "description"
    t.index ["site_id", "site_event_id"], name: "index_events_on_site_and_site_event_id", unique: true
    t.index ["site_id"], name: "index_events_on_site_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.string "follower_id", null: false
    t.string "followed_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["follower_id", "followed_id"], name: "index_friendships_on_follower_id_and_followed_id", unique: true
  end

  create_table "sites", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tweet_crawl_settings", force: :cascade do |t|
    t.string "max_id", default: "0", null: false
    t.string "since_id", default: "0", null: false
    t.string "search_base_max_id", default: "0", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tweets", id: :string, force: :cascade do |t|
    t.text "text", null: false
    t.datetime "tweeted_at", null: false
    t.string "user_id", null: false
    t.string "quoted_tweet_id"
    t.string "retweeted_tweet_id"
    t.bigint "event_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "retweet_last_updated_at"
    t.index ["event_id"], name: "index_tweets_on_event_id"
    t.index ["quoted_tweet_id"], name: "index_tweets_on_quoted_tweet_id"
    t.index ["retweeted_tweet_id"], name: "index_tweets_on_retweeted_tweet_id"
    t.index ["user_id"], name: "index_tweets_on_user_id"
  end

  create_table "user_event_settings", force: :cascade do |t|
    t.string "user_id", null: false
    t.integer "event_sort_type", default: 0, null: false
    t.integer "time_filter_type", default: 1, null: false
    t.integer "friends_filter_type", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_event_settings_on_user_id"
  end

  create_table "user_tokens", force: :cascade do |t|
    t.string "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "access_token_ciphertext"
    t.text "access_token_secret_ciphertext"
    t.index ["user_id"], name: "index_user_tokens_on_user_id"
  end

  create_table "users", id: :string, force: :cascade do |t|
    t.string "screen_name", null: false
    t.string "name", null: false
    t.string "profile_image", null: false
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "following_last_updated_at"
    t.string "following_next_cursor", default: "-1", null: false
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  add_foreign_key "crawl_tweets", "users"
  add_foreign_key "events", "sites"
  add_foreign_key "friendships", "users", column: "followed_id"
  add_foreign_key "friendships", "users", column: "follower_id"
  add_foreign_key "tweets", "events"
  add_foreign_key "tweets", "tweets", column: "quoted_tweet_id"
  add_foreign_key "tweets", "tweets", column: "retweeted_tweet_id"
  add_foreign_key "tweets", "users"
  add_foreign_key "user_event_settings", "users"
  add_foreign_key "user_tokens", "users"
end
