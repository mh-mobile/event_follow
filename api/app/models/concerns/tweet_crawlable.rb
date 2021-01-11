# frozen_string_literal: true

module TweetCrawlable
  extend ActiveSupport::Concern

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

  def search_tweets
    @tweets ||= begin
      twitter_request = TwitterRequest.create
      twitter_request.tweets(max_id: crawl_setting_value[:max_id], since_id: crawl_setting_value[:since_id])
    end
    @tweets.statuses
  end

  def tweets_max_fetched?(tweets)
    tweets.count == TwitterClient::SEARCH_COUNT
  end

  def update_crawl_setting(tweets)
    if tweets_max_fetched?(tweets)
      update_to_additional_loading(tweets)
    else
      update_to_recent_loading(tweets)
    end

    TweetCrawlSetting.first.update(max_id: crawl_setting_value[:max_id],
                                   since_id: crawl_setting_value[:since_id],
                                   search_base_max_id: crawl_setting_value[:search_base_max_id])
  end

  # 追加のツイート読み込み設定に更新
  def update_to_additional_loading(tweets)
    # search_base_max_idの設定値更新```
    crawl_setting_value[:search_base_max_id] = tweets.first.id_str if crawl_setting_value[:max_id] == "0"

    # max_idの設定値更新
    crawl_setting_value[:max_id] = (tweets.last.id_str.to_i - 1).to_s
  end

  # 最新のツイート読み込み設定に更新
  def update_to_recent_loading(tweets)
    # since_idの設定値更新
    if crawl_setting_value[:max_id] == "0"
      crawl_setting_value[:since_id] = tweets.first.id_str if tweets.count > 0
    else
      crawl_setting_value[:since_id] = crawl_setting_value[:search_base_max_id]
    end

    # max_idの設定値更新
    crawl_setting_value[:max_id] = "0"
  end

  def update_tweet_users(tweets)
    User.insert_all(inserted_tweet_users(tweets.map(&:user)))
  end

  def update_crawl_tweets(tweets)
    CrawlTweet.insert_all(inserted_crawl_tweets(tweets))
  end
end
