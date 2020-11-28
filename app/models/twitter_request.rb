# frozen_string_literal: true

class TwitterRequest
  def self.create(oauth_token: nil, oauth_token_secret: nil)
    twitter_client = TwitterClient.new(
      app_token: ENV["OAUTH_APP_TOKEN"],
      oauth_consumer_key: ENV["OAUTH_CONSUMER_KEY"],
      oauth_token: oauth_token,
      oauth_consumer_secret: ENV["OAUTH_CONSUMER_SECRET"],
      oauth_token_secret: oauth_token_secret
    )
    TwitterRequest.new(twitter_client)
  end

  def initialize(twitter_client)
    @twitter_client = twitter_client
  end

  def tweets(max_id: nil, since_id: nil)
    @twitter_client.search(q: "(url:doorkeeper.jp/events OR url:connpass.com/event/) -filter:retweets -filter:replies filter:links", max_id: max_id, since_id: since_id)
  end

  def quoted_tweets(tweet_url)
    @twitter_client.search(q: tweet_url)
  end

  def retweets(tweet_id)
    @twtter_client.retweets(tweet_id)
  end

  def following(cursor: -1)
    @twitter_client.following(cursor: cursor)
  end
end
