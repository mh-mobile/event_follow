# frozen_string_literal: true

class AddRetweetLastUpdatedAtToTweets < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :retweet_last_updated_at, :datetime, null: true
  end
end
