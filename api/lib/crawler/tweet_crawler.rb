 # frozen_string_literal: true

 class TweetCrawler
  include BaseCrawlable
  include TweetCrawlable

   def self.start

     twitter_request = TwitterRequest.create
     tweets = twitter_request.tweets(max_id: crawl_setting_value[:max_id], since_id: crawl_setting_value[:since_id])

     return if tweets.statuses.count == 0

     if tweets.statuses.count == TwitterClient::SEARCH_COUNT
       crawl_setting_value[:search_base_max_id] = (tweets.statuses.first.id_str) if crawl_setting_value[:max_id] == "0"
       crawl_setting_value[:max_id] = (tweets.statuses.last.id_str.to_i - 1).to_s
     else
       crawl_setting_value[:max_id] = "0"
       crawl_setting_value[:since_id] = crawl_setting_value[:search_base_max_id]
     end

     update_crawl_setting

     User.insert_all(tweet_users(tweets.statuses.map(&:user)))
     CrawlTweet.insert_all(inserted_crawl_tweets(tweets.statuses))
   end
 end
