# frozen_string_literal: true

class AddRetweetLastUpdatedAtToTweets < ActiveRecord::Migration[6.0]
  def change
    add_column :tweets, :retweet_last_updated_at, :datetime, null: true
  end
end
