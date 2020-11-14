# frozen_string_literal: true

class CreateTweets < ActiveRecord::Migration[6.0]
  def change
    create_table :tweets, id: false do |t|
      t.bigint :id, null: false
      t.text :text, null: false
      t.datetime :tweeted_at, null: false
      t.references :user, null: false, foreign_key: true
      t.references :quoted_tweet, null: true
      t.references :retweeted_tweet, null: true
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end

    reversible do |direction|
      direction.up { execute "ALTER TABLE tweets ADD PRIMARY KEY (id);" }
    end

    add_foreign_key :tweets, :tweets, column: :quoted_tweet_id
    add_foreign_key :tweets, :tweets, column: :retweeted_tweet_id
  end
end
