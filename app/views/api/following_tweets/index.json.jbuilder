# frozen_string_literal: true

json.array! @tweets do |tweet|
  json.partial! "api/following_tweets/tweet", tweet: tweet
end
