# frozen_string_literal: true

class TwitterRequest
  def initialize(twitter_client)
    @twitter_client = twitter_client
  end

  def tweets(since_id)
  end

  def quoted_tweets
  end

  def following(user_id, since_id)
  end
end
