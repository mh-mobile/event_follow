# frozen_string_literal: true

class RetweetCrawler < DaemonSpawn::Base
    def start(args)
      loop do
        target_tweet = Tweet.normal_tweets
                              .where(tweeted_at: Time.current.ago(24.hours)..Time.current.ago(4.hours))
                            .or(Tweet.normal_tweets
                              .where(retweet_last_updated_at: nil)
                              .where(tweeted_at: Time.current.ago(24.hours)..Time.current.ago(4.hours)))
                            .order(Arel.sql("retweet_last_updated_at asc NULLS FIRST")).limit(1).first
        next unless target_tweet
  
        twitter_request = TwitterRequest.create
        retweets = twitter_request.retweets(target_tweet.id)
        puts "retweets: #{retweets}"
  
        time = Time.current
        target_tweet.update(retweet_last_updated_at: time)
  
        users = retweets.map do |tweet|
          {
            id: tweet.user.id,
            name: tweet.user.name,
            screen_name: tweet.user.screen_name,
            profile_image: tweet.user.profile_image_url_https,
            created_at: time,
            updated_at: time
          }
        end
        User.insert_all(users)
  
        inserted_retweets = retweets.map do |tweet|
          {
            id: tweet.id,
            text: tweet.text,
            tweeted_at:  DateTime.parse(tweet.created_at).utc.iso8601,
            user_id: tweet.user.id,
            retweeted_tweet_id: target_tweet.id,
            event_id: target_tweet.event_id,
            created_at: time,
            updated_at: time
          }
        end
  
        Tweet.insert_all(inserted_retweets)
  
        tweet_url = "https://twitter.com/#{target_tweet.user.screen_name}/status/#{target_tweet.id}"
        puts "target_url: #{tweet_url}"
        quoted_retweets = twitter_request.quoted_tweets(tweet_url)
        puts "quoted_retweets: #{quoted_retweets}"
  
        next if quoted_retweets.statuses.count == 0
  
        time = Time.current
        users = quoted_retweets.statuses.map do |tweet|
          {
            id: tweet.user.id,
            name: tweet.user.name,
            screen_name: tweet.user.screen_name,
            profile_image: tweet.user.profile_image_url_https,
            created_at: time,
            updated_at: time
          }
        end
        User.insert_all(users)
  
        inserted_quoted_retweets = tweets.statuses.map do |tweet|
          {
            id: tweet.id,
            text: tweet.text,
            tweeted_at:  DateTime.parse(tweet.created_at).utc.iso8601,
            user_id: tweet.user.id,
            quoted_tweet_id: target_tweet.id,
            event_id: target_tweet.event_id,
            created_at: time,
            updated_at: time
          }
        end
        Tweet.insert_all(inserted_quoted_retweets)
  
      ensure
        sleep 5
      end
    end
  
    def stop
      puts "stop  : #{Time.now}"
    end
  end
  
  RetweetCrawler.spawn!({
    working_dir: Rails.root,
    pid_file: "#{Rails.root}/tmp/retweet_crawler.pid",
    log_file: "#{Rails.root}/tmp/retweet_crawler.log",
    sync_log: true,
    singleton: true
  })
