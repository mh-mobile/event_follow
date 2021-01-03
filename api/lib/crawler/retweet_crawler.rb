# frozen_string_literal: true

class RetweetCrawler
  include BaseCrawlable

  def self.start
    target_tweet = Tweet.normal_tweets
                          .where(tweeted_at: Time.current.ago(24.hours)..Time.current.ago(4.hours))
                        .or(Tweet.normal_tweets
                          .where(retweet_last_updated_at: nil)
                          .where(tweeted_at: Time.current.ago(24.hours)..Time.current.ago(4.hours)))
                        .order(Arel.sql("retweet_last_updated_at asc NULLS FIRST")).limit(1).first
    return unless target_tweet

    twitter_request = TwitterRequest.create
    retweets = twitter_request.retweets(target_tweet.id)

    time = Time.current
    target_tweet.update(retweet_last_updated_at: time)

    User.insert_all(tweet_users(retweets.map(&:user)))
    Tweet.insert_all(inserted_retweets(retweets, event_id: target_tweet.event_id, retweeted_tweet_id: target_tweet.id))

    tweet_url = "https://twitter.com/#{target_tweet.user.screen_name}/status/#{target_tweet.id}"
    quoted_retweets = twitter_request.quoted_tweets(tweet_url)

    return if quoted_retweets.statuses.count == 0

    User.insert_all(tweet_users(quoted_retweets.statuses.map(&:user)))
    Tweet.insert_all(inserted_quoted_retweets(quoted_retweets, event_id: target_tweet.event_id, quoted_tweet_id: target_tweet.id))
  end
end
