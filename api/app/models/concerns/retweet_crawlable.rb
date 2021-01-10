# frozen_string_literal: true

module RetweetCrawlable
  extend ActiveSupport::Concern

  def target_tweet
    @target_tweet ||=begin
      Tweet.normal_tweets
      .where(tweeted_at: Time.current.ago(24.hours)..Time.current.ago(4.hours))
      .order(Arel.sql("retweet_last_updated_at asc NULLS FIRST")).limit(1).first
    end
  end

  def twitter_request
    @twitter_request ||= TwitterRequest.create
  end

  def search_retweets(target_tweet)
    @retweets ||= twitter_request.retweets(target_tweet.id)
  end

  def search_quoted_retweets(target_tweet)
    tweet_url = "https://twitter.com/#{target_tweet.user.screen_name}/status/#{target_tweet.id}"
    @quoted_retweets ||= twitter_request.quoted_tweets(tweet_url).statuses
  end

  def update_target_tweet(target_tweet)
    time = Time.current
    target_tweet.update(retweet_last_updated_at: time)
  end

  def update_tweets_users(retweets)
    User.insert_all(inserted_tweet_users(retweets.map(&:user)))
  end

  def update_retweets(retweets)
    Tweet.insert_all(retweets)
  end

  def inserted_retweet_objects(tweets, event_id:, retweeted_tweet_id: nil, quoted_tweet_id: nil)
    time = Time.current
    tweets.map do |tweet|
      {
        id: tweet.id_str,
        text: tweet.text,
        tweeted_at:  DateTime.parse(tweet.created_at).utc.iso8601,
        user_id: tweet.user.id_str,
        retweeted_tweet_id: retweeted_tweet_id,
        quoted_tweet_id: quoted_tweet_id,
        event_id: event_id,
        created_at: time,
        updated_at: time
      }
    end
  end

  def inserted_retweets(tweets, event_id:, retweeted_tweet_id:)
    inserted_retweet_objects(tweets, event_id: event_id,
                              retweeted_tweet_id: retweeted_tweet_id,
                              quoted_tweet_id: nil)
  end

  def inserted_quoted_retweets(tweets, event_id:, quoted_tweet_id:)
    inserted_retweet_objects(tweets, event_id: event_id,
                              retweeted_tweet_id: nil,
                              quoted_tweet_id: quoted_tweet_id)
  end
end
