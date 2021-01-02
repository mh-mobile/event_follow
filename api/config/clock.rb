# frozen_string_literal: true

require_relative "../config/boot"
require_relative "../config/environment"
require "clockwork"

module Clockwork
  handler do |job|
    case job
    when "frequent.job"
      puts "5秒ごとの処理"
      TweetCrawler.start
    when "event_crawler.job"
      puts "イベントとの処理"
      EventCrawler.start
    when "retweet_crawler.job"
      puts "リツイートとの処理"
      RetweetCrawler.start
    when "following_crawler.job"
      puts "フォローの処理"
      FollowingCrawler.start
    end
  end

  every(5.seconds, "frequent.job", thread: true)
  every(10.seconds, "event_crawler.job", thread: true)
  every(5.seconds, "retweet_crawler.job", thread: true)
  every(1.minutes, "following_crawler.job", thread: true)
end
