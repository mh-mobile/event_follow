# frozen_string_literal: true

class Tweet < ApplicationRecord
  belongs_to :user
  belongs_to :quoted_tweet, class_name: "Tweet", optional: true
  belongs_to :retweeted_tweet, class_name: "Tweet", optional: true
  belongs_to :event

  scope :tweets_for_event, -> (event_id) { where(event_id: event_id) }
  scope :following_tweets, -> (user) { where(user_id: user.following.ids) }
  scope :normal_tweets, -> { where(quoted_tweet_id: nil, retweeted_tweet_id: nil) }

  validates :user_id, presence: true
  validates :event_id, presence: true
  validates :text, presence: true
  validates :tweeted_at, presence: true
end
