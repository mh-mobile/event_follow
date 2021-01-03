# frozen_string_literal: true

require_relative "../config/boot"
require_relative "../config/environment"
require "clockwork"

module Clockwork
  handler do |job|
    case job
    when "tweet_crawler.job"
      TweetCrawler.new.execute
    when "event_crawler.job"
      EventCrawler.new.execute
    when "retweet_crawler.job"
      RetweetCrawler.new.execute
    when "following_crawler.job"
      FollowingCrawler.new.execute
    end
  end

  every(5.seconds, "tweet_crawler.job", thread: true)
  every(10.seconds, "event_crawler.job", thread: true)
  every(5.seconds, "retweet_crawler.job", thread: true)
  every(1.minutes, "following_crawler.job", thread: true)
end
