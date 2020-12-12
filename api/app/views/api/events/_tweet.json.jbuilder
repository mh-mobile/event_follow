# frozen_string_literal: true

json.(tweet, :id, :text, :tweeted_at, :quoted_tweet_id, :retweeted_tweet_id)
json.user do
  json.partial! "api/users/user", user: tweet.user
end
