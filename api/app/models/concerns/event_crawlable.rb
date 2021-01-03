# frozen_string_literal: true

module EventCrawlable
  extend ActiveSupport::Concern

  def crawl_tweet
    @crawl_tweet ||= CrawlTweet.order(tweeted_at: :asc).limit(1).first
  end

  def update_tweet(event_id, crawl_tweet)
    tweet = Tweet.find_or_initialize_by(id: crawl_tweet.id)
    tweet.update(
      text: crawl_tweet.text,
      tweeted_at: crawl_tweet.tweeted_at,
      event_id: event_id,
      user_id: crawl_tweet.user_id,
      quoted_tweet_id: nil,
      retweeted_tweet_id: nil
    )
  end

  def delete_crawl_tweet(crawl_tweet)
    CrawlTweet.find_by(id: crawl_tweet.id)&.destroy
  end
end
