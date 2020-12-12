# frozen_string_literal: true

class CreateCrawlTweets < ActiveRecord::Migration[6.0]
  def change
    create_table :crawl_tweets, id: false do |t|
      t.bigint :id, null: false
      t.text :text, null: false
      t.datetime :tweeted_at, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    reversible do |direction|
      direction.up { execute "ALTER TABLE crawl_tweets ADD PRIMARY KEY (id);" }
    end
  end
end
