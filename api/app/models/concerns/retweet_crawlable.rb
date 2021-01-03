module RetweetCrawlable
  extend ActiveSupport::Concern

  module ClassMethods
    def inserted_retweet_objects(tweets, event_id: ,retweeted_tweet_id: nil, quoted_tweet_id: nil)
      time = Time.current
      tweets.statuses.map do |tweet|
        {
          id: tweet.id_str,
          text: tweet.text,
          tweeted_at:  DateTime.parse(tweet.created_at).utc.iso8601,
          user_id: tweet.user.id_str,
          retweeted_tweet_id: retweeted_tweet_id,
          quoted_tweet_id: quoted_tweet_id,
          event_id: event_id,
          created_at: time,
          updated_at: time
        }
      end

      def inserted_retweets(tweets, event_id: ,retweeted_tweet_id:)
        inserted_retweet_objects(tweets, event_id: event_id,
                                  retweeted_tweet_id: retweeted_tweet_id,
                                  quoted_tweet_id: nil)
      end

      def inserted_quoted_retweets(tweets, event_id: ,quoted_tweet_id:)
        inserted_retweet_objects(tweets, event_id: event_id,
                                  retweeted_tweet_id: nil,
                                  quoted_tweet_id: quoted_tweet_id)
      end
    end
  end

end
