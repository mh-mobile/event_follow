  # frozen_string_literal: true

  class TweetCrawler < DaemonSpawn::Base
    def start(args)
      @max_id = 0
      @since_id = 0

      while true
        sleep 5

        twitter_request = TwitterRequest.create
        tweets = twitter_request.tweets(max_id: @max_id, since_id: @since_id)

        next if tweets.statuses.count == 0

        if tweets.statuses.count == TwitterClient::SEARCH_COUNT
          @max_id = tweets.statuses[-1].id - 1
        else
          @max_id = 0
          @since_id = tweets.search_metadata.max_id
        end

        time = Time.current
        users = tweets.statuses.map do |tweet|
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

        crawl_tweets = tweets.statuses.map do |tweet|
          {
            id: tweet.id,
            text: tweet.text,
            tweeted_at:  DateTime.parse(tweet.created_at).utc.iso8601,
            user_id: tweet.user.id,
            event_url: tweet.entities.urls.first&.expanded_url || "",
            created_at: time,
            updated_at: time
          }
        end

        CrawlTweet.insert_all(crawl_tweets)
      end
    end

    def stop
      puts "stop  : #{Time.now}"
    end
  end

  TweetCrawler.spawn!({
    working_dir: Rails.root,
    pid_file: "#{Rails.root}/tmp/tweet_crawler.pid",
    log_file: "#{Rails.root}/tmp/tweet_crawler.log",
    sync_log: true,
    singleton: true
  })
