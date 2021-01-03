# frozen_string_literal: true

class RetweetCrawler
  def self.start
    target_tweet = Tweet.normal_tweets
                          .where(tweeted_at: Time.current.ago(24.hours)..Time.current.ago(4.hours))
                        .or(Tweet.normal_tweets
                          .where(retweet_last_updated_at: nil)
                          .where(tweeted_at: Time.current.ago(24.hours)..Time.current.ago(4.hours)))
                        .order(Arel.sql("retweet_last_updated_at asc NULLS FIRST")).limit(1).first
    return unless target_tweet

    twitter_request = TwitterRequest.create
    retweets = twitter_request.retweets(target_tweet.id)

    time = Time.current
    target_tweet.update(retweet_last_updated_at: time)

    users = retweets.map do |tweet|
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

    inserted_retweets = retweets.map do |tweet|
      {
        id: tweet.id_str,
        text: tweet.text,
        tweeted_at:  DateTime.parse(tweet.created_at).utc.iso8601,
        user_id: tweet.user.id_str,
        retweeted_tweet_id: target_tweet.id,
        event_id: target_tweet.event_id,
        created_at: time,
        updated_at: time
      }
    end

    Tweet.insert_all(inserted_retweets)

    tweet_url = "https://twitter.com/#{target_tweet.user.screen_name}/status/#{target_tweet.id}"
    quoted_retweets = twitter_request.quoted_tweets(tweet_url)

    return if quoted_retweets.statuses.count == 0

    time = Time.current
    users = quoted_retweets.statuses.map do |tweet|
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

    inserted_quoted_retweets = tweets.statuses.map do |tweet|
      {
        id: tweet.id_str,
        text: tweet.text,
        tweeted_at:  DateTime.parse(tweet.created_at).utc.iso8601,
        user_id: tweet.user.id_str,
        quoted_tweet_id: target_tweet.id,
        event_id: target_tweet.event_id,
        created_at: time,
        updated_at: time
      }
    end
    Tweet.insert_all(inserted_quoted_retweets)
  end
end
