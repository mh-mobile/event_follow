 # frozen_string_literal: true

 class TweetCrawler
   include BaseCrawlable
   include TweetCrawlable

   def execute
     tweets = search_tweets
     update_crawl_setting(tweets)
     return if tweets.empty?
     update_tweet_users(tweets)
     update_crawl_tweets(tweets)
   end
 end
