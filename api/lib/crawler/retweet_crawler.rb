# frozen_string_literal: true

class RetweetCrawler
  include BaseCrawlable
  include RetweetCrawlable

  def execute
    return unless target_tweet
    update_target_tweet(target_tweet)
    process_retweets(target_tweet)
    process_quoted_retweets(target_tweet)
  end

  def process_retweets(target_tweet)
    retweets = search_retweets(target_tweet)
    return if retweets.empty?
    update_tweets_users(retweets)
    update_retweets(inserted_retweets(retweets, event_id: target_tweet.event_id,
                                                retweeted_tweet_id: target_tweet.id))
  end

  def process_quoted_retweets(target_tweet)
    quoted_retweets = search_quoted_retweets(target_tweet)
    return if quoted_retweets.empty?
    update_tweets_users(quoted_retweets)
    update_retweets(inserted_quoted_retweets(quoted_retweets, event_id: target_tweet.event_id,
                                                              quoted_tweet_id: target_tweet.id))
  end
end
