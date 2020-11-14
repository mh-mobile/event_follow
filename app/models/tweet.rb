class Tweet < ApplicationRecord
  belongs_to :user
  belongs_to :quoted_tweet
  belongs_to :retweeted_tweet
  belongs_to :event
end
