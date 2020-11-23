# frozen_string_literal: true

class TwitterRequest
  def self.create(oauth_token:, oauth_token_secret:)
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

  def tweets(since_id: 0)
    @twitter_client.search(q: "(url:doorkeeper.jp/events OR url:connpass.com/event/) filter:links", since_id: since_id)
  end

  def quoted_tweets
  end

  def following(cursor: -1)
    @twitter_client.following(cursor: cursor)
  end
end
