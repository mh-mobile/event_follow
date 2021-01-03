 # frozen_string_literal: true

 class TweetCrawler
  include BaseCrawlable

   def self.start
     crawl_setting = TweetCrawlSetting.first
     @max_id = crawl_setting.max_id
     @since_id = crawl_setting.since_id
     @search_base_max_id = crawl_setting.search_base_max_id

     twitter_request = TwitterRequest.create
     tweets = twitter_request.tweets(max_id: @max_id, since_id: @since_id)

     return if tweets.statuses.count == 0

     if tweets.statuses.count == TwitterClient::SEARCH_COUNT
       @search_base_max_id = (tweets.statuses.first.id_str) if @max_id == "0"
       @max_id = (tweets.statuses.last.id_str.to_i - 1).to_s
     else
       @max_id = "0"
       @since_id = @search_base_max_id
     end

     crawl_setting.update(max_id: @max_id, since_id: @since_id, search_base_max_id: @search_base_max_id)

     User.insert_all(tweet_users(tweets.statuses.map(&:user)))

     time = Time.current
     crawl_tweets = tweets.statuses.map do |tweet|
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

     CrawlTweet.insert_all(crawl_tweets)
   end
 end
