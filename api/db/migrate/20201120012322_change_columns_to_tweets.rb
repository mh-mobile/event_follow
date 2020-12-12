# frozen_string_literal: true

class ChangeColumnsToTweets < ActiveRecord::Migration[6.0]
  def change
    change_column_null :tweets, :quoted_tweet_id, true
    change_column_null :tweets, :retweeted_tweet_id, true
  end
end
