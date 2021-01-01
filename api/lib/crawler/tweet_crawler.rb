 # frozen_string_literal: true

 class TweetCrawler
  def start
    @max_id = 0
    @since_id = 0

    loop do
      twitter_request = TwitterRequest.create
      puts "max_id: #{@max_id}, since_id: #{@since_id}"
      tweets = twitter_request.tweets(max_id: @max_id, since_id: @since_id)

      puts "tweets.status.count: #{tweets.statuses.count}"
      next if tweets.statuses.count == 0

      if tweets.statuses.count == TwitterClient::SEARCH_COUNT
        @max_id = tweets.statuses.last.id_str.to_i - 1
        puts "*****"
      else
        @max_id = 0
        @since_id = tweets.search_metadata.max_id_str.to_i
        puts "======="
      end

      time = Time.current
      users = tweets.statuses.map do |tweet|
        {
          id: tweet.user.id_str,
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
    ensure
      sleep 5
    end
  end

  def stop
    puts "stop  : #{Time.now}"
  end
end
