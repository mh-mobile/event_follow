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

    def crawl_setting_value
      @crawl_setting_value ||= tweet_crawl_setting
    end

    def tweet_crawl_setting
      setting = TweetCrawlSetting.first
      {
        max_id: setting.max_id,
        since_id: setting.since_id,
        search_base_max_id: setting.search_base_max_id
      }
    end

    def update_crawl_setting
      TweetCrawlSetting.first.update(max_id: crawl_setting_value[:max_id],
                                     since_id: crawl_setting_value[:since_id],
                                     search_base_max_id: crawl_setting_value[:search_base_max_id])
    end

  end
end
