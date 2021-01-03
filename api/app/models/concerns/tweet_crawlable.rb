module TweetCrawlable
  extend ActiveSupport::Concern

  module ClassMethods
    def inserted_crawl_tweets(tweets)
      time = Time.current
      tweets.map do |tweet|
        {
          id: tweet.id_str,
          text: tweet.text,
          tweeted_at:  DateTime.parse(tweet.created_at).utc.iso8601,
          user_id: tweet.user.id_str,
          event_url: tweet.entities.urls.first&.expanded_url || "",
          created_at: time,
          updated_at: time
        }
      end
    end
  end
end
