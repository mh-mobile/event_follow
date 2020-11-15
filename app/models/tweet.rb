# frozen_string_literal: true

class Tweet < ApplicationRecord
  belongs_to :user
  belongs_to :quoted_tweet, class_name: "Tweet"
  belongs_to :retweeted_tweet, class_name: "Tweet"
  belongs_to :event

  scope :following_tweets, -> (user) { where(user_id: user.following.ids) }

  validates :user_id, presence: true
  validates :event_id, presence: true
  validates :text, presence: true
  validates :tweeted_at, presence: true
end