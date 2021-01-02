# frozen_string_literal: true

class EventCrawler
  def self.start
    crawl_tweets = CrawlTweet.order(tweeted_at: :asc).limit(1)
    return if crawl_tweets.length == 0

    tweet = crawl_tweets.first
    tweet_id = tweet.id
    tweet_text = tweet.text
    tweeted_at = tweet.tweeted_at
    event_url = tweet.event_url
    user_id = tweet.user_id

    params = { event_url: event_url }
    event_store = EventStore.new(params)
    if event_store.save
      event_id = event_store.event.id

      tweet = Tweet.find_or_initialize_by(id: tweet_id)
      tweet.update(
        text: tweet_text,
        tweeted_at: tweeted_at,
        event_id: event_id,
        user_id: user_id,
        quoted_tweet_id: nil,
        retweeted_tweet_id: nil
      )
      tweet.save
    end
    CrawlTweet.find(tweet_id).destroy
  end
end
