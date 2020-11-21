json.array! @tweets do |tweet|
  json.partial! "api/following_tweets/tweet", tweet: tweet
end
