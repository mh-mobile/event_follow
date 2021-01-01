# frozen_string_literal: true

class CreateTweets < ActiveRecord::Migration[6.0]
  def change
    create_table :tweets, id: false do |t|
      t.string :id, null: false
      t.text :text, null: false
      t.datetime :tweeted_at, null: false
      t.string :user_id, null: false
      t.string :quoted_tweet_id, null: true
      t.string :retweeted_tweet_id, null: true
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end

    reversible do |direction|
      direction.up { execute "ALTER TABLE tweets ADD PRIMARY KEY (id);" }
    end

    add_foreign_key :tweets, :users
    add_foreign_key :tweets, :tweets, column: :quoted_tweet_id
    add_foreign_key :tweets, :tweets, column: :retweeted_tweet_id
    add_index :tweets, :user_id
    add_index :tweets, :quoted_tweet_id
    add_index :tweets, :retweeted_tweet_id
  end
end
