# frozen_string_literal: true

class CreateCrawlTweets < ActiveRecord::Migration[6.0]
  def change
    create_table :crawl_tweets, id: false do |t|
      t.string :id, null: false
      t.text :text, null: false
      t.datetime :tweeted_at, null: false
      t.string :user_id, null: false

      t.timestamps
    end

    reversible do |direction|
      direction.up { execute "ALTER TABLE crawl_tweets ADD PRIMARY KEY (id);" }
    end

    add_foreign_key :crawl_tweets, :users
    add_index :crawl_tweets, :user_id
  end
end
